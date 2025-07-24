package utils;

import model.entity.Product;
import model.entity.ProductImage;
import java.util.Collection;

/**
 * Utility class for handling product image operations
 */
public class ProductImageUtil {
    
    /**
     * Get the main image URL for a product
     * @param product the product to get main image for
     * @return the main image URL or null if no image exists
     */
    public static String getMainImageUrl(Product product) {
        if (product == null || product.getProductImagesCollection() == null) {
            return null;
        }
        
        Collection<ProductImage> images = product.getProductImagesCollection();
        if (images.isEmpty()) {
            return null;
        }
        
        // First try to find the main image
        for (ProductImage img : images) {
            if (Boolean.TRUE.equals(img.getIsMainImage())) {
                return img.getImageUrl();
            }
        }
        
        // Fallback: return first image if exists
        return images.iterator().next().getImageUrl();
    }
    
    /**
     * Check if a product has any images
     * @param product the product to check
     * @return true if product has images, false otherwise
     */
    public static boolean hasImages(Product product) {
        return product != null && 
               product.getProductImagesCollection() != null && 
               !product.getProductImagesCollection().isEmpty();
    }
} 