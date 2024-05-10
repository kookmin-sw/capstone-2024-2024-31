package km.cd.backend.category;

import static org.assertj.core.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertThrows;

import km.cd.backend.category.dto.CategoryRequest;
import km.cd.backend.category.entity.Category;
import km.cd.backend.category.repository.CategoryRepository;
import km.cd.backend.category.service.CategoryService;
import km.cd.backend.common.error.CustomException;
import km.cd.backend.helper.IntegrationTest;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

public class CategoryServiceTest extends IntegrationTest {
    @Autowired
    CategoryService categoryService;
    @Autowired
    CategoryRepository categoryRepository;
    
    //SavedID
    private CategoryRequest createCategoryDTO(String testBranch, String testCode, String testName) {
        CategoryRequest categoryRequest = new CategoryRequest();
        categoryRequest.setBranch(testBranch);
        categoryRequest.setCode(testCode);
        categoryRequest.setName(testName);
        return categoryRequest;
    }
    
    //Find Category
    
    private Category findCategory (Long savedId) {
        return categoryRepository.findById(savedId).orElseThrow(IllegalArgumentException::new);
    }
    
    @Test
    public void 카테고리_저장_테스트 () {
        //given
        CategoryRequest categoryRequest = createCategoryDTO("TestBranch", "TestCode", "TestName");
        Long savedId = categoryService.saveCategory(categoryRequest);
        
        //when
        Category category = findCategory(savedId);
        
        //then
        assertThat(category.getCode()).isEqualTo("TestCode");
    }
    
    @Test
    public void 카테고리_업데이트_테스트 () {
        //given
        CategoryRequest categoryRequest = createCategoryDTO("TestBranch", "TestCode", "TestName");
        Long savedId = categoryService.saveCategory(categoryRequest);
        
        Category category = findCategory(savedId);
        CategoryRequest targetCategory = new CategoryRequest(category);
        targetCategory.setName("UpdateCategory");
        
        //when
        Long updateId = categoryService.updateCategory("TestBranch", "TestCode", targetCategory);
        Category updatedCategory = findCategory(updateId);
        
        //then
        assertThat(updatedCategory.getName()).isEqualTo("UpdateCategory");
    }
    
    @Test
    public void 카테고리_삭제_테스트 () {
        //given
        CategoryRequest categoryRequest = createCategoryDTO("TestBranch", "TestCode", "TestName");
        Long savedId = categoryService.saveCategory(categoryRequest);
        
        //when
        categoryService.deleteCategory(savedId);
        
        //then
        CustomException e =
            assertThrows(CustomException.class,
                () -> categoryService.findCategory(savedId));
//        assertThat(e.getMessage()).isEqualTo("해당 카테고리를 찾을 수 없습니다.");
    }
}
