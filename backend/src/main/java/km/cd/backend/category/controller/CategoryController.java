package km.cd.backend.category.controller;

import jakarta.validation.constraints.NotBlank;
import km.cd.backend.category.dto.CategoryListResponse;
import km.cd.backend.category.dto.CategoryRequest;
import km.cd.backend.category.dto.CategoryMapResponse;
import km.cd.backend.category.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/categories")
@RequiredArgsConstructor
public class CategoryController {
    
    private final CategoryService categoryService;
    
    @PostMapping("/save")
    public ResponseEntity<Long> saveCategory(CategoryRequest categoryRequest) {
        return ResponseEntity.ok(categoryService.saveCategory(categoryRequest));
    }
    
    @GetMapping("/{branch}")
    public ResponseEntity<CategoryMapResponse> getCategoryByBranch(@PathVariable String branch) {
        return ResponseEntity.ok(categoryService.getCategoryByBranch(branch));
    }
    
    @GetMapping("/all")
    public ResponseEntity<CategoryListResponse> getAllCategories() {
        return ResponseEntity.ok(categoryService.getAllCategories());
    }
    
    @PutMapping("/{branch}/{code}")
    @ResponseBody
    public ResponseEntity<Long> updateCategory (
        @PathVariable (name = "branch") @NotBlank String branch,
        @PathVariable (name = "code") @NotBlank String code,
        CategoryRequest categoryRequest) {
        return ResponseEntity.ok(categoryService.updateCategory(branch, code, categoryRequest));
    }
    
    @DeleteMapping("/{branch}/{code}")
    @ResponseBody
    public ResponseEntity<String> deleteCategory (
        @PathVariable (name = "branch") @NotBlank String branch,
        @PathVariable (name = "code") @NotBlank String code) {
        categoryService.deleteCategory(branch, code);
        return ResponseEntity.ok().build();
    }
}
