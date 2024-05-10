package km.cd.backend.category.repository;

import java.util.List;
import java.util.Optional;
import km.cd.backend.category.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    
    Optional<Category> findByName(String name);
    Optional<Category> findByBranchAndName(String branch, String name);
    Optional<Category> findByBranchAndCode(String branch, String code);
    
    Boolean existsByBranchAndName(String branch, String name);
    
}