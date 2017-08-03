pragma solidity ^0.4.11;
contract Rent{
    struct Property{
        address landlord; // Stores the address for landlord
        address renter; // Stores the address for the person renting the property
        uint monthlyRentETH; // Stores the monthly rent amount in ether
        uint deposit; // Stores the deposit value in Ether held for damages
        bool isAvailable; // Stores boolean to determine if the house is empty
        bool isDamaged; // Stores boolean to determine if renter damaged the property during the lease
    }
    
    Property property;
    
    // Initialize the contract
    function Rent(){
        property.landlord = msg.sender;
        property.isAvailable = true;
        property.isDamaged = false;
    }
    
    /*
    Check the property can be rented by the requested person
    Rent the property for the renter
    */
    function RentHouse(){
        // Do not rent the property if it is already rented
        require(property.isAvailable);
        
        // Do not rent the property to the landlord
        require(msg.sender != getLandlord()); 
        
        // Do not rent the property if the renter cannot pay the month
        require(msg.sender.balance >= (getRent() + getDeposit()));
        
        // Mark the property as taken
        property.isAvailable = false;
        
        // Mark the renter as the sender
        setRenter(msg.sender);
        
        // Pay the deposit to the landlord
        getLandlord().transfer(getDeposit());
        
        // Hold the money until it is end of the month
        
    }
    
    /*
    Sets the monthly rent to amount in Ether
    */
    function setRent(uint amount){
        // Only allow the landlord to set the rent
        require(msg.sender == getLandlord());
        
        property.monthlyRentETH = amount;
    }
    
    /*
    Sets the renter for the propery
    */
    function setRenter(address renter){
        require(msg.sender == getLandlord());
        
        property.renter = renter;
    }
    
    /*
    Sets the deposit value in Ether
    */
    function setDeposit(uint amount){
        // Only allow the landlord to set the deposit value
        require(msg.sender == getLandlord());
        
        // Cannot change while it is being rented
        require(getAvailability());
        
        property.deposit = amount;
    }
    
    /*
    Set the renter damage to be true
    */
    function setRenterDamaged(){
        // Only allow the landlord to mark the property as damaged
        require(msg.sender == getLandlord());
        
        property.isDamaged = true;
    }
    
    /*
    Sets the isAvailable attribute of a property
    */
    function setAvailability(bool availability){
        // Only allow the landlord to set availability
        require(msg.sender == getLandlord());
        
        property.isAvailable = availability;
    }
    
    /*
    Gets the monthly rent in Ether
    */
    function getRent() constant returns (uint){
        return property.monthlyRentETH;
    }
    
    /*
    Gets the deposit in Ether
    */
    function getDeposit() constant returns (uint){
        return property.deposit;
    }
    
    /*
    Gets the person renting the property
    */
    function getRenter() constant returns (address){
        return property.renter;
    }
    
    /*
    Gets the landlord for the property
    */
    function getLandlord() constant returns (address){
        return property.landlord;
    }
    /*
    Gets the damage of the renter
    */
    function getIsDamaged() constant returns (bool){
        return property.isDamaged;
    }
    /*
    Gets the availability of the property
    */
    function getAvailability() constant returns (bool){
        return property.isAvailable;
    }
    /*
    Terminates the lease agreement
    */
    function endLease(){
        // Only allow the landlord to close the lease
        require(msg.sender == getLandlord());
        
        // Reset the availability
        setAvailability(true);
        
        // Payback the deposit
        if(getIsDamaged() == false){
            getRenter().transfer(getDeposit());
        }
        
        //Reset Availability
        property.isAvailable = false;
        
        // Reset the renter
        
        
    }
    
}
