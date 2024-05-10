package km.cd.backend.category.dto;

import java.util.List;
import km.cd.backend.category.entity.Category;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Setter @Getter
@AllArgsConstructor
public class CategoryListResponse {
    List<Category> categories;
}
