pragma solidity ^0.4.18;

contract RandomArray {

    uint[200] public array;
    
    function RandomArray(uint _maxNum) public {
        for (uint i = 0; i < _maxNum; i++) {
            array[i] = i;
        }
    }
    
    function random(uint _hash, uint _n, uint _maxNum) public view returns (uint[]){
        require(_n <= _maxNum);
        require(_maxNum < array.length);

        uint[] memory randomNums = new uint[](_n);
        uint[200] memory memoryArray = array;
        
        for (uint i = _maxNum; i > _maxNum - _n; i--) {
            uint randomI = _hash % i;
            
            uint t = memoryArray[randomI];
            memoryArray[randomI] = memoryArray[i];
            
            memoryArray[i] = t; 
            
            randomNums[_maxNum - i] = memoryArray[i];
        }
        
        return randomNums;
    }
}