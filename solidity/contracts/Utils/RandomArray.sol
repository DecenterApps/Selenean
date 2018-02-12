pragma solidity ^0.4.18;

contract RandomArray {

    uint[200] public numbers;
    
    function RandomArray(uint _maxNum) public {
        for (uint i = 0; i < _maxNum; i++) {
            numbers[i] = i;
        }
    }
    
    function random(uint _hash, uint _n, uint _maxNum) public view returns (uint[]){
        require(_n <= _maxNum);
        require(_maxNum < numbers.length);

        uint[] memory randomNums = new uint[](_n);
        uint[200] memory memoryArray = numbers;
        
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