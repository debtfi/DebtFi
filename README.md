# DebtFi
https://debt.financial/  

## Project Description
![image](https://user-images.githubusercontent.com/19934260/175816134-33d1c288-9825-474f-9f7e-174d39dcf26f.png)


With tumbling crypto prices and potential domino effects in the crypto market, diversification of the asset and access to decoupled earning opportunities are sought after more than ever by crypto investors.  
On the other hand, there is a huge need for venture debt to finance top-performing startups in the emerging markets.   
Due to high inflation and the acute funding gap, venture debt can earn a high yield of around 15-20% p.a. in USD although the debt is safer and more secure instrument than venture equity.   
DebtFi democratizes access to these venture debt opportunities for individual crypto investors. On our protocol, they can safely invest in the senior debt tranche of the vetted and validated startups in USDC.   

Our core team consisting of African VC founders and experienced hackers has unparalleled strength in building this protocol with necessary early supporters.   

There are 4 participants incentivized and aligned by our DebtFi token to initiate and execute the venture debt deals on the protocol.   
First, Deal Creators are active VC investors on the ground who source venture debt deals from their portfolio companies and their network. 
They negotiate the basic terms of the debt deals with startups, bring them to the protocol, and provide the junior debt tranche. 
As a counterparty of Deal Creators, there are Borrowers, namely, startups that need venture debt to facilitate their operation and fuel their business growth. 
Thirdly, Validators are accountants, lawyers, and other experts, who assess and validate the deals proposed by Deal Creators. 
Finally, there are Investors, who provide the senior debt tranche to the deals approved by Validators.

## How it's Made
Purpose This project has a strong focus on creating a social impact using P2P technology. Considering practical benefits, the DebtFi prototype is deployed on Polygon due to its cheap gas cost and scalability.

The Lending protocol is implemented as a set of extended ERC-20 tokens (Vault Tokens), each of which represents the liabilities among the 4 participants (i.e. Borrowers, Deal Creators, Investors, and Validators) on the protocol and also enables them to transact in a trusted manner.

For this prototype, only smart contract was developed without the frontend, for the ease of demo. In our presentation, we will look at transactions on the actual testnet, and illustrate the transaction flow.

Architecture Based on the explanation above DebtFi needs to meet the following requirement in its architecture. a. Deal Creator concludes the term sheet. b. Validator assesses the deal and approve/reject the deal. c. Investor and Deal Creator deposits senior debt tranche and junior debt tranche respectively. d. Borrower receives the fund, completes repayment within the due date.
e. Once Borrower completes repayment, the fund is allocated and paid to each participant.

We use USDC as a funding currency on the protocol, as USD is the main currency used for debt financing to the startups.

We developed a smart contract that utilizes original Vault Token that guarantees repayment of the loan to Investors and Deal Creators.

This Vault Token is used to manage lending and borrowing among the 4 participants (Borrower, Investor, Validator, and Deal Creator). It functions as a guarantee to redeem loans and converts into USDC.

Implementation of smart contract for DebtFi is based on ERC-4626, an extension of ERC20. USDC and Vault Token have equal values (1 USDC = 1 Vault Token). Vault Token is deopyed by each debt deal.

internal implementation Based on the above architecture, a detailed implementation is shown below a. Deal Creator concludes the term sheet.

Deploy a contract with the termsheet information in the constructor
The termsheet has these parameters below Borrower Address Pool Size Interest Rate Payment Deadline

b. Validator assesses the deal and approve/reject the deal.
Validator calls validate() function
Only users with the validator role call can call the function
This function has Deal Creator Pool as argument
The validator audits the project and determines the funding rate between the VC (Deal Creator) and the investor.
Mints a Vault Token to the validator with the same value as the repayment at the time of repayment (mint function is internal)

c. Investor and Deal Creator deposits senior debt tranche and junior debt tranche respectively.
Investor and Deal Creator call deposit() function
Transfer money to contract address
Argument has asset(USDC)
Mints a Vault Token to the Investor and Deal Creator with the same value as the repayment at the time of repayment (mint function is internal)

d. Borrower receives the fund, completes repayment within the due date.
borrower calls borrow() function
Only the user who has been granted the borrower role calls the function
borrower calls the payback() function
Flag in payback() to check whether the borrower has repaid the loan as per the termsheet.

e. Once Borrower completes repayment, the fund is allocated and paid to each participant.
Investor, Deal Creator and Validator call redeem() function.
Contracts transfers USDC to each actor.
Burns the vault token internally

future options As a next implementation, we will deploy governance token across the venture debt deals. The main purpose of governance token is to align the long-term incentives of the participants and ensure a trusted network on the protocol. For example, governance token is staked by Deal Creators when they bring venture deals to the protocol.

In order to improve UX for investors, other new features such as automatic deposit functions along the preset conditions by the investors will be added.  

## Build
This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```
