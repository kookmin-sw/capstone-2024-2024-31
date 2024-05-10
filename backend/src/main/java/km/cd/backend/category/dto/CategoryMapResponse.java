package km.cd.backend.category.dto;

import java.util.HashMap;
import java.util.Map;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class CategoryMapResponse {
    Map<String, CategoryRequest> data = new HashMap<>();
}
