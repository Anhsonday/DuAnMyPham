package dao.interfaces;

import java.util.List;
import model.entity.Wishlist;

public interface WishlistDAO extends IGenericDAO<Wishlist, Integer> {
    List<Wishlist> findByUserId(Integer userId);
    boolean isProductInWishlist(Integer userId, Integer productId);
    int getWishlistCount(Integer userId);
    void removeFromWishlist(Integer userId, Integer productId);
}
