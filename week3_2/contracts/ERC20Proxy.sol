// SPDX-License-Identifier:MIT

pragma solidity ^0.8.4;

// 实现一个可升级的ERC20 Token

library StorageSlot {
    struct AddressSlot {
        address value;
    }

    function getAddressSlot(
        bytes32 slot
    ) internal pure returns (AddressSlot storage r) {
        assembly {
            r.slot := slot
        }
    }
}
// GeneralProxy 在代理合约里不具体命名某个代理执行逻辑合约函数 而是通过fallback方式实现
// 调用合约某个不存在的会触发fallback()
contract ERC20Proxy  {

    // address public admin;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name, string memory symbol) {
        // admin = msg.sender;
        _name = name;
        _symbol = symbol;
    }

    // 记录槽位 逻辑合约地址存放在这个槽位
    bytes32 private constant IMPLEMENTATION_SLOT =
        bytes32(uint(keccak256("eip1967.proxy.implementation")) - 1);

    
    function _delegate(address _implementation) internal virtual {
        // 通过汇编方式获取返回值
        assembly {

            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                // revert(p, s) - end execution, revert state changes, return data mem[p…(p+s))
                revert(0, returndatasize())
            }
            default {
                // return(p, s) - end execution, return data mem[p…(p+s))
                return(0, returndatasize())
            }
        }
    }

    function _fallback() private {
        _delegate(_getImplementation());
    }

    fallback() external payable {
        // require(msg.sender != admin);
        _fallback();
    }

    receive() external payable {
        _fallback();
    }

    function _getImplementation() private view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }

    function _setImplementation(address _implementation) private {
        require(_implementation.code.length > 0, "implementation is not contract");
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = _implementation;
    }

    function upgradeTo(address _implementation) external {
        // if (msg.sender != admin) revert();
        _setImplementation(_implementation);
    }

}
