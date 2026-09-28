package warakron.pbru.ac.th.projectcal.data

enum class Gender { MALE, FEMALE }
enum class GoalType { WEIGHT_LOSS, WEIGHT_GAIN }
enum class MealType { BREAKFAST, LUNCH, DINNER }

data class UserProfile(
    val gender: Gender = Gender.FEMALE,
    val age: Int = 25,
    val height: Float = 165f,
    val weight: Float = 60f,
    val goal: GoalType = GoalType.WEIGHT_LOSS,
    val targetCalories: Int = 1800
)

data class MealItem(
    val id: String,
    val mealType: MealType,
    val title: String,
    val calories: Int,
    val protein: Float,
    val imageUrl: String
)

data class Ingredient(
    val name: String,
    val amount: String,
    val isChecked: Boolean = false
)

data class CookingStep(
    val stepNumber: Int,
    val description: String,
    val imageUrl: String = ""
)

data class Recipe(
    val id: String,
    val title: String,
    val calories: Int,
    val prepTimeMinutes: Int,
    val difficulty: String,
    val protein: Float,
    val carbs: Float,
    val fat: Float,
    val imageUrl: String,
    val ingredients: List<Ingredient>,
    val steps: List<CookingStep>,
    var isBookmarked: Boolean = false,
    var isLiked: Boolean = false
)
