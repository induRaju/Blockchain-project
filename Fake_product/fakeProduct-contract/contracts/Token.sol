//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20{
     address creater;
     address allowedMarketPlace;
    
    constructor(uint intialsupply ) ERC20('cur', 'at') {
       creater = msg.sender;
      _mint(msg.sender, intialsupply * (10 ** decimals()));
    }
    //function approve(address spender ,uint256 amount) public virtual override  returns (bool)
    //{
      //_approve(spender,allowedMarketPlace,amount);
      //return true;
    //}
    function setAllowedMarketPlace(address _allowedMarketPlace) public {
        allowedMarketPlace = _allowedMarketPlace;
        transfer(_allowedMarketPlace, 100000);
    }
}