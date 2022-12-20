//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./Token.sol";
contract Fakeproduct2{
    address owner;
    string []codes;
    Token token;

    struct Retailer
    {
        string Retailer_name;
        string Retailer_loc;
        string password;
    }

    struct manufacturer
    {
        string manufacturer_name;
        string manu_Loc;
        string Desc;
        string brand_name;
        string retailer;
        string model;
        uint status;
        uint price;
        address account;
    }
   
    modifier onlyOwner() 
    {
        require(msg.sender == owner);
        _;
    }
    constructor (address _add) public payable
    {
        owner = msg.sender;
        token = Token(_add);
    }  
    mapping (string => manufacturer) manufacturer_data; //mapping of the code to Manufacturer
  
    mapping (string => Retailer) Retailer_data;  //mapping of Retailer mail id to retailer

    function loginuser(string memory email,string memory password ) public view returns (bool)
    {
        if(keccak256(abi.encodePacked(Retailer_data[email].password)) == keccak256(abi.encodePacked(password)))
        {
           return true;
        }
        else 
            return false;
    }
    function getBalance() public view returns (uint256)
    {
        return token.balanceOf(msg.sender);
    }
    function getproductdetails(string  memory _code1) public onlyOwner view returns ( string memory,  string memory, uint,uint,string memory,address,string memory) 
       {
        return (manufacturer_data[_code1].brand_name,manufacturer_data[_code1].model ,manufacturer_data[_code1].status,manufacturer_data[_code1].price,Retailer_data[manufacturer_data[_code1].retailer].Retailer_name,manufacturer_data[_code1].account,Retailer_data[manufacturer_data[_code1].retailer].Retailer_loc) ;
       }
    //Recording retailer
    function CreateRetailer(string memory email,string memory name,string memory loc,string memory password)  public payable returns (uint)
    {
        Retailer memory retailer;
        retailer.Retailer_name=name;
        retailer.Retailer_loc=loc;
        retailer.password=password;
        Retailer_data[email]=retailer;
        token.transfer(msg.sender, 1000);
    
    return uint256(1);
    }

    //Get retailer details
    function Getretailer(string memory mail) public view returns (string memory, string memory)
    {
       
        return (Retailer_data[mail].Retailer_name, Retailer_data[mail].Retailer_loc);
    }
    function getcodes()  public view returns (string[] memory)
    { 
        return codes;
    }

    //This condition is to check only if manufacturers are creating the products
    function checkManufacturer() public view returns(bool)  {
       if (owner == msg.sender) {
            return true;
        } 
        else {
            return false;
        }
    }
    function  createManufacturer(string  memory _code, string memory brand_name,string memory  model,string memory  desc,string memory name,string memory  loc,uint status,uint price ) public onlyOwner returns (uint)
    {
        codes.push(_code);
        manufacturer memory manufact;
        manufact.brand_name = brand_name;
        manufact.model = model;
        manufact.Desc = desc;
        manufact.manufacturer_name = name;
        manufact.manu_Loc = loc;
        manufact.status=status;
        manufact.price=price;
        manufact.account=msg.sender;
        manufacturer_data[_code] = manufact;
       
        return 1;
    }
    function changeownership(string memory _code1,string memory mail) public returns (uint)
    { 
        if( manufacturer_data[_code1].status==0||manufacturer_data[_code1].status==2)
        {
            manufacturer_data[_code1].account=msg.sender;
            manufacturer_data[_code1].status=1; //someone had purchased it not elgible to sell
            manufacturer_data[_code1].retailer=mail;
            for(uint i=0; i< codes.length; i++) {
                if(keccak256(abi.encodePacked(codes[i])) == keccak256(abi.encodePacked(_code1))) {
                    delete codes[i];
                }
            }
            return 1;
        }
    }

    // function Buy(string memory _code1,string memory mail ) public payable returns (uint)
    // {
       
    //     return 1;
    // }

    function issold(string memory _code1) public view returns(bool) 
    {
        if(manufacturer_data[_code1].status==2 && msg.sender== manufacturer_data[_code1].account)
        {
            return true;
        }
        else 
        {
            return false;
        }
    }
   
   
    function sell(string memory _code1,string memory mail,uint price ) public payable
    {
        //sold it
        if(keccak256(abi.encodePacked(manufacturer_data[_code1].retailer)) ==keccak256(abi.encodePacked(mail)) && msg.sender== manufacturer_data[_code1].account)
        {
            manufacturer_data[_code1].price= price;
            manufacturer_data[_code1].status=2;
            codes.push(_code1);
        }
    }

    function getaccount(string memory _code1) public view returns (address)
    {
       return (manufacturer_data[_code1].account);
    }

    function checkbalance(string memory _code1) public view returns (bool)
    {
        if(manufacturer_data[_code1].price >token.balanceOf(msg.sender)){
           return false;
       }
       return true;  
    }

    //for reteriving the code details to display for retailers to purchase
    function getCodeDetailsforowner(string  memory _code1) public  view returns ( string memory,  string memory, string memory,  string memory,  string memory,uint,uint) 
    {
        return (manufacturer_data[_code1].brand_name,manufacturer_data[_code1].Desc, manufacturer_data[_code1].model ,manufacturer_data[_code1].manufacturer_name, manufacturer_data[_code1].manu_Loc,manufacturer_data[_code1].status,manufacturer_data[_code1].price) ;
    }

    function getCodeDetailsforretailers(string  memory _code1) public view returns ( string memory,  string memory,uint )
    {
        return (manufacturer_data[_code1].brand_name,manufacturer_data[_code1].Desc,manufacturer_data[_code1].price);
    }

    function getretailerdetailsforthecode(string memory code2) public view returns (string memory, string memory)  {
        return (Retailer_data[manufacturer_data[code2].retailer].Retailer_name, Retailer_data[manufacturer_data[code2].retailer].Retailer_loc);
    }
}
