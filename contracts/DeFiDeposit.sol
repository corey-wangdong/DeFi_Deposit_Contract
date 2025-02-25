// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeFiDeposit {
    // 记录用户存款余额的映射
    mapping(address => uint256) public balances;
    // 存款函数，接收ETH并更新余额
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // 提取指定金额的ETH
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        // 先更新余额以防止重入攻击
        balances[msg.sender] -= amount;
        // 发送ETH给调用者
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // 提取调用者的全部存款
    function ownerWithdraw() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance to withdraw");
        // 清零余额前先保存金额
        balances[msg.sender] = 0;
        // 发送全部ETH给调用者
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
