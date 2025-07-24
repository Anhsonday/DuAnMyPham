package service.interfaces;

import java.util.List;
import model.entity.Wishlist;

public interface WishlistService extends IGenericService<Wishlist> {
    List<Wishlist> findByUserId(Integer userId);
    List<Wishlist> getUserWishlist(Integer userId);
    boolean addToWishlist(Integer userId, Integer productId);
    boolean removeFromWishlist(Integer userId, Integer productId);
    boolean toggleWishlistItem(Integer userId, Integer productId);
    boolean toggleWishlist(Integer userId, Integer productId);
    boolean isProductInWishlist(Integer userId, Integer productId);
    boolean isInWishlist(Integer userId, Integer productId);
    int getWishlistCount(Integer userId);
    void clearWishlist(Integer userId);
    boolean removeWishlistItem(Integer wishlistId, Integer userId);
    List<?> getMostWishedProducts(int limit);
}
