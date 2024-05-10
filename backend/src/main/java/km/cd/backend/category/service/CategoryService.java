package km.cd.backend.category.service;

import jakarta.transaction.Transactional;
import java.util.List;
import java.util.stream.Collectors;
import km.cd.backend.category.dto.CategoryListResponse;
import km.cd.backend.category.dto.CategoryRequest;
import km.cd.backend.category.dto.CategoryMapResponse;
import km.cd.backend.category.entity.Category;
import km.cd.backend.category.repository.CategoryRepository;
import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Transactional
public class CategoryService {
    
    private final CategoryRepository categoryRepository;
    
    public Long saveCategory(CategoryRequest categoryRequest) {
        
        Category category = categoryRequest.toEntity();
        //대분류 등록
        if (categoryRequest.getParentCategoryName() == null) {
            
            //JPA 사용하여 DB에서 branch와 name의 중복값을 검사. (대분류에서만 가능)
            if (categoryRepository.existsByBranchAndName(categoryRequest.getBranch(), categoryRequest.getName())) {
                throw new CustomException(ExceptionCode.INVALID_BRANCH_NAME);
            }
            
            Category rootCategory = categoryRepository.findByBranchAndName(categoryRequest.getBranch(), "ROOT")
                .orElseGet(() ->
                    Category.builder()
                        .name("ROOT")
                        .code("ROOT")
                        .branch(categoryRequest.getBranch())
                        .level(0)
                        .build()
                );
            if (!categoryRepository.existsByBranchAndName(categoryRequest.getBranch(), "ROOT")) {
                categoryRepository.save(rootCategory);
            }
            category.setParentCategory(rootCategory);
            category.setLevel(1);
            //중, 소분류 등록
        } else {
            String parentCategoryName = categoryRequest.getParentCategoryName();
            Category parentCategory = categoryRepository.findByBranchAndName(
                    categoryRequest.getBranch(), parentCategoryName)
                .orElseThrow(() -> new CustomException(ExceptionCode.NOT_FOUND_PARENT_CATEGORY));
            category.setLevel(parentCategory.getLevel() + 1);
            category.setParentCategory(parentCategory);
            parentCategory.getSubCategory().add(category);
        }
        
        //category.setLive(true);
        return categoryRepository.save(category).getId();
    }
    
    public CategoryMapResponse getCategoryByBranch(String branch) {
        Category category = categoryRepository.findByBranchAndCode(branch, "ROOT")
            .orElseThrow(() -> new CustomException(ExceptionCode.NOT_FOUND_PARENT_CATEGORY));
        
        CategoryRequest categoryRequest = new CategoryRequest(category);
        
        CategoryMapResponse categoryMapResponse = new CategoryMapResponse();
        categoryMapResponse.getData().put(categoryRequest.getName(), categoryRequest);
        
        return categoryMapResponse;
    }
    
    public CategoryListResponse getAllCategories() {
        List<Category> allCategories = categoryRepository.findAll();
        
        List<Category> levelOneCategories = allCategories.stream()
            .filter(category -> category.getLevel() == 1)
            .collect(Collectors.toList());
        
        return new CategoryListResponse(levelOneCategories);
    }
    
    public void deleteCategory(Category category) {
//        Category category = findCategory(categoryId);
        if (category.getSubCategory().size() == 0) { //하위 카테고리 없을 경우
            Category parentCategory = findCategory(category.getParentCategory().getId());
            if (!parentCategory.getName().equals("ROOT")) { // ROOT가 아닌 다른 부모가 있을 경우
                parentCategory.getSubCategory().remove(category);
            }
            categoryRepository.deleteById(category.getId());
        } else { //하위 카테고리 있을 경우
            Category parentCategory = findCategory(category.getParentCategory().getId());
            //ROOT아닌 부모가 있을 경우
            if (!parentCategory.getName().equals("ROOT")) {
                parentCategory.getSubCategory().remove(category);
            }
            category.setName("Deleted category");
        }
    }
    
    public void deleteCategory(Long categoryId) {
        Category category = findCategory(categoryId);
        deleteCategory(category);
    }
    
    public void deleteCategory(String branch, String code) {
        Category category = categoryRepository.findByBranchAndCode(branch, code).orElseThrow(() -> new CustomException(ExceptionCode.NOT_FOUND_CATEGORY));
        deleteCategory(category);
    }
    public Long updateCategory(String branch, String code, CategoryRequest categoryRequest) {
        Category category = categoryRepository.findByBranchAndCode(branch, code).orElseThrow(() -> new CustomException(ExceptionCode.NOT_FOUND_CATEGORY));
        
        category.setName(categoryRequest.getName());
        
        return category.getId();
    }
    
    public Category findCategory(Long categoryId) {
        return categoryRepository.findById(categoryId).orElseThrow(() ->new CustomException(ExceptionCode.NOT_FOUND_CATEGORY));
    }
    
}
