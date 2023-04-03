// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";

contract Vault {
    mapping(address => uint256) public balances;
    address tokenAddress;

    constructor(address tokenAddress_) {
        tokenAddress = tokenAddress_;
    }

    /**
     * @dev deposit ERC20 Token
     * need to approve firstly
     */
    function deposit(uint256 amount) public {
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
    }

    /**
     * @dev withdraw ERC20 Token
     */
    function withdraw(uint256 amount) public {
        // check balance > amount
        require(balances[msg.sender] > amount, "balance is not enough");
        balances[msg.sender] -= amount;
        IERC20(tokenAddress).transfer(msg.sender, amount);
    }

    /**
     * @dev deposit ERC20Permit Token
     * deposit with signature
     * 这里的签名可以通过钱包签名也可以通过Web3.py签名
     */
    function depositWithSignature(
        address user,
        uint256 amount,
        bytes memory signature
    ) public {
        // 通过签名生成r s v 三个值
        bytes32 r;
        bytes32 s;
        uint8 v;
        // 目前只能通过assmebly(内联汇编)来从签名中获得r,s,v的值
        assembly {
            /*
            前32 bytes存储签名的长度 (动态数组存储规则)
            add(sig, 32) = sig的指针 + 32
            等效为略过signature的前32 bytes
            mload(p) 载入从内存地址p起始的接下来32 bytes数据
            */
            // 读取长度数据后的32 bytes
            r := mload(add(signature, 0x20))
            // 读取之后的32 bytes
            s := mload(add(signature, 0x40))
            // 读取最后一个byte
            v := byte(0, mload(add(signature, 0x60)))
        }

        // 检查签名是否正确
        IERC20Permit(tokenAddress).permit(
            msg.sender,
            address(this),
            amount,
            1 days,
            v,
            r,
            s
        );
        // 实现转账
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
        balances[user] = amount;
    }

    /**
     * @dev create signature
     *  _PERMIT_TYPEHASH =
     *  keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
     * keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
     */

    function getMsgHash(
        address spender,
        uint256 value
    ) public view returns (bytes32) {
        bytes32 _PERMIT_TYPEHASH = keccak256(
            "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
        );
        // 打包消息
        bytes32 messageHash = keccak256(
            abi.encode(_PERMIT_TYPEHASH, msg.sender, spender, value, 0, 1 days)
        );
        // 计算以太坊消息
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    messageHash
                )
            );
    }
}
