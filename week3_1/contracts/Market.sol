// SPDX-License-Identifier: MIT

/* 编写一个市场合约：使自己发行ERC20 Token来买卖NFT 
   NFT持有者可以上架NFT（设置价格 多少个Token购买多少个NFT）
 */
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//
contract Market is IERC721Receiver {
    // 上架事件
    event List(
        address indexed seller,
        address indexed nftAddr,
        uint256 indexed tokenId,
        uint256 price
    );

    // 下架事件
    event Revoke(
        address indexed seller,
        address indexed nftAddr,
        uint256 tokenId
    );

    // 购买事件
    event Purchase(
        address indexed buyer,
        address indexed nftAddr,
        uint256 tokenId
    );

    struct Order {
        address owner;
        uint256 price;
    }

    // contract =>tokenId => address
    mapping(address => mapping(uint256 => Order)) nftList;

    // support token address
    address public erc20Addr;

    constructor(address _erc20Addr) {
        erc20Addr = _erc20Addr;
    }

    // onERC721Received
    // ERC721安全转账函数会检查接受合约是否实现了onERC721Received函数, 并返回正确的selector,
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    // 上架
    function list(uint256 tokenId, address nftAddress, uint256 price) public {
        IERC721 _nft = IERC721(nftAddress);

        require(_nft.ownerOf(tokenId) == msg.sender, "token not owned by user");
        // approve first
        require(_nft.getApproved(tokenId) == address(this), "Need Approval");
        // 转移NFT
        _nft.safeTransferFrom(msg.sender, address(this), tokenId);
        // 记录
        Order storage order = nftList[nftAddress][tokenId];
        order.owner = msg.sender;
        order.price = price;

        emit List(msg.sender, nftAddress, tokenId, price);
    }

    // 下架
    function revoke(address nftAddress, uint256 tokenId) public {
        Order memory order = nftList[nftAddress][tokenId];
        require(order.owner == msg.sender, "Not Owner");

        IERC721 _nft = IERC721(nftAddress);
        require(_nft.ownerOf(tokenId) == address(this), "Invalid Order");

        _nft.safeTransferFrom(address(this), msg.sender, tokenId);
        delete nftList[nftAddress][tokenId];

        emit Revoke(msg.sender, nftAddress, tokenId);
    }

    // 购买
    function purchase(address nftAddress, uint256 tokenId) public {
        Order storage order = nftList[nftAddress][tokenId];
        require(order.price > 0, "Invalid Price");

        IERC20 supportToken = IERC20(erc20Addr);

        require(
            supportToken.balanceOf(msg.sender) >= order.price,
            "balance not enough"
        );

        IERC721 nft = IERC721(nftAddress);

        // transfer nft
        nft.safeTransferFrom(address(this), msg.sender, tokenId);

        // approve first
        // transfer erc20 token
        supportToken.transferFrom(msg.sender, order.owner, order.price);

        emit Purchase(msg.sender, nftAddress, tokenId);
    }
}
