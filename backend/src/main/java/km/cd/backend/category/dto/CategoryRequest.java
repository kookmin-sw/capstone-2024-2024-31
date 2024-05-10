package km.cd.backend.category.dto;

import java.util.Map;
import java.util.stream.Collectors;
import km.cd.backend.category.entity.Category;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter
@NoArgsConstructor
public class CategoryRequest {
    
    private Long categoryId;
    private String branch;
    private String code;
    private String name;
    private String parentCategoryName;
    private Integer level;
    private Map<String, CategoryRequest> children;
    
    public CategoryRequest(Category entity) {
        
        this.categoryId = entity.getId();
        this.branch = entity.getBranch();
        this.code = entity.getCode();
        this.name = entity.getName();
        this.level = entity.getLevel();
        if(entity.getParentCategory() == null) {
            
            this.parentCategoryName = "대분류";
            
        } else {
            
            this.parentCategoryName = entity.getParentCategory().getName();
            
        }
        
        this.children = entity.getSubCategory() == null ? null :
            entity.getSubCategory().stream().collect(Collectors.toMap(Category::getCode, CategoryRequest::new));
    }
    
    public Category toEntity () {
        return Category.builder()
            .branch(branch)
            .code(code)
            .level(level)
            .name(name)
            .build();
    }
}
