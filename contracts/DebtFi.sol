//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract DebtFi is AccessControl, ERC20 {
    using SafeERC20 for IERC20;
    
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Deposit(address indexed owner, uint256 assets, uint256 shares);

    event Validate(address indexed validator, uint256 juniorPoolSize, uint256 shares);

    event Redeem(
        address indexed receiver,
        uint256 assets,
        uint256 shares
    );

    bytes32 public constant DEAL_CREATOR_ROLE = keccak256("DEAL_CREATOR_ROLE");
    bytes32 public constant VALIDATOR_ROLE = keccak256("VALIDATOR_ROLE");
    bytes32 public constant BORROWER_ROLE = keccak256("BORROWER_ROLE");

    uint256 public constant DEAL_CREATOR_RATE = 0.2;
    uint256 public constant LENDER_RATE = 0.2;
    uint256 public constant VALIDATOR_RATE = 0.2;

    IERC20 public immutable asset;

    address public immutable borrower;
    uint256 public immutable poolSize;
    uint256 public immutable interestRate; 
    uint256 public immutable deadline;

    uint256 private _totalAssets;

    constructor(
        IERC20 _asset,
        string memory _name,
        string memory _symbol,
        address _borrower,
        uint256 _poolSize,
        uint256 _interestRate,
        uint256 _deadline
    ) ERC20(_name, _symbol) {
        asset = _asset;
        borrower = _borrower;
        poolSize = _poolSize;
        interestRate = _interestRate;
        deadline = _deadline;
        _setupRole(BORROWER_ROLE, _borrower);
    }

    function setDealCreators(address[] memory _dealCreators) public virtual returns (uint256 shares) {
        for (uint i = 0; i < _dealCreators.length; i++)
            grantRole(DEAL_CREATOR_ROLE, _dealCreators[i]);
    }

    function setValidators(address[] memory _validators) public virtual returns (uint256 shares) {
        for (uint i = 0; i < _validators.length; i++)
            grantRole(VALIDATOR_ROLE, _validators[i]);
    }

    function validate(uint256 juniorPoolSize) public virtual returns (uint256 shares) {
        // Check for rounding error since we round down in previewDeposit.
        require((shares = previewValidate()) != 0, "ZERO_SHARES");

        _mint(_msgSender(), shares);

        emit Validate(_msgSender(), juniorPoolSize, shares);
    }

    function deposit(uint256 assets) public virtual returns (uint256 shares) {
        // Check for rounding error since we round down in previewDeposit.
        require((shares = previewDeposit(assets)) != 0, "ZERO_SHARES");

        // Need to transfer before minting or ERC777s could reenter.
        asset.safeTransferFrom(_msgSender(), address(this), assets);

        _mint(_msgSender(), shares);

        emit Deposit(_msgSender(), assets, shares);
    }

    function borrow(uint256 assets) public virtual onlyRole(BORROWER_ROLE) {
        // TODO: Check pool is full
        asset.safeTransfer(_msgSender(), assets);

        emit Deposit(_msgSender(), assets, shares);
    }

    function payback(
        uint256 assets
    ) public virtual onlyRole(BORROWER_ROLE) {
        asset.safeTransferFrom(_msgSender(), address(this), assets);

        emit Deposit(_msgSender(), assets, shares);
    }

    function redeem(
        uint256 shares
    ) public virtual returns (uint256 assets) {
        // Check for rounding error since we round down in previewRedeem.
        require((assets = previewRedeem(shares)) != 0, "ZERO_ASSETS");

        _burn(_msgSender(), shares);

        emit Redeem(_msgSender(), assets, shares);

        asset.safeTransfer(_msgSender(), assets);
    }

    /*//////////////////////////////////////////////////////////////
                            ACCOUNTING LOGIC
    //////////////////////////////////////////////////////////////*/

    function decimals() public view override returns (uint8) {
        return 6; // USDC
    }

    function totalAssets() public view virtual returns (uint256);

    function convertToShares(uint256 assets) public view virtual returns (uint256) {
        uint256 supply = totalSupply(); // Saves an extra SLOAD if totalSupply is non-zero.

        return supply == 0 ? assets : assets.mulDivDown(supply, totalAssets());
    }

    function convertToAssets(uint256 shares) public view virtual returns (uint256) {
        uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.

        return supply == 0 ? shares : shares.mulDivDown(totalAssets(), supply);
    }

    function previewDeposit(uint256 assets) public view virtual returns (uint256) {
        return convertToShares(assets);
    }

    function previewValidate() public view virtual returns (uint256) {
        return convertToShares(assets);
    }

    // function previewMint(uint256 shares) public view virtual returns (uint256) {
    //     uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.

    //     return supply == 0 ? shares : shares.mulDivUp(totalAssets(), supply);
    // }

    // function previewWithdraw(uint256 assets) public view virtual returns (uint256) {
    //     uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.

    //     return supply == 0 ? assets : assets.mulDivUp(supply, totalAssets());
    // }

    function previewRedeem(uint256 shares) public view virtual returns (uint256) {
        return convertToAssets(shares);
    }

    /*//////////////////////////////////////////////////////////////
                     DEPOSIT/WITHDRAWAL LIMIT LOGIC
    //////////////////////////////////////////////////////////////*/

    function maxDeposit(address) public view virtual returns (uint256) {
        return type(uint256).max;
    }

    // function maxMint(address) public view virtual returns (uint256) {
    //     return type(uint256).max;
    // }

    // function maxWithdraw(address owner) public view virtual returns (uint256) {
    //     return convertToAssets(balanceOf[owner]);
    // }

    function maxRedeem(address owner) public view virtual returns (uint256) {
        return balanceOf[owner];
    }
}