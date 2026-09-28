package warakron.pbru.ac.th.projectcal.viewmodel

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import warakron.pbru.ac.th.projectcal.data.*

class HealthViewModel : ViewModel() {

    private val _userProfile = MutableStateFlow(UserProfile())
    val userProfile: StateFlow<UserProfile> = _userProfile.asStateFlow()

    private val _consumedCalories = MutableStateFlow(520)
    val consumedCalories: StateFlow<Int> = _consumedCalories.asStateFlow()

    private val _dailyMeals = MutableStateFlow(
        listOf(
            MealItem("1", MealType.BREAKFAST, "โจ๊กหมูสับใส่ไข่ลวก", 350, 18f, "url_breakfast"),
            MealItem("2", MealType.LUNCH, "ข้าวกะเพราอกไก่ไข่ดาวไร้น้ำมัน", 520, 35f, "url_lunch"),
            MealItem("3", MealType.DINNER, "สลัดอกไก่ย่างน้ำใส", 400, 28f, "url_dinner")
        )
    )
    val dailyMeals: StateFlow<List<MealItem>> = _dailyMeals.asStateFlow()

    private val _selectedRecipe = MutableStateFlow(
        Recipe(
            id = "recipe_1",
            title = "ข้าวกะเพราอกไก่ไข่ดาวไร้น้ำมัน",
            calories = 520,
            prepTimeMinutes = 15,
            difficulty = "ง่ายมาก",
            protein = 35f,
            carbs = 45f,
            fat = 12f,
            imageUrl = "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8",
            ingredients = listOf(
                Ingredient("อกไก่หั่นชิ้น", "150 กรัม"),
                Ingredient("ใบกะเพราออร์แกนิก", "1 กำมือ"),
                Ingredient("พริกขี้หนูสวน & กระเทียม", "1 ช้อนโต๊ะ"),
                Ingredient("น้ำปลาสูตรลดโซเดียม", "1 ช้อนชา"),
                Ingredient("ไข่ไก่ (ทอดด้วยน้ำเปล่า)", "1 ฟอง"),
                Ingredient("ข้าวกล้องไรซ์เบอร์รี", "1 ทัพพี")
            ),
            steps = listOf(
                CookingStep(1, "โขลกพริกและกระเทียมพอหยาบ เตรียมไว้สำหรับผัด"),
                CookingStep(2, "ตั้งกระทะเทฟลอน ใส่กระเทียมและพริกผัดกับน้ำเปล่าเล็กน้อยจนหอม ไม่ใช้น้ำมัน"),
                CookingStep(3, "ใส่ออกไก่หั่นชิ้นลงไปผัดจนสุก ปรุงรสด้วยน้ำปลาสูตรลดโซเดียม ใส่ใบกะเพรา ปิดไฟทันที"),
                CookingStep(4, "ทอดไข่ดาวในกระทะเทฟลอนโดยใช้น้ำเปล่าแทนน้ำมัน ตักเสิร์ฟคู่กับข้าวกล้องไรซ์เบอร์รี")
            ),
            isBookmarked = true,
            isLiked = true
        )
    )
    val selectedRecipe: StateFlow<Recipe> = _selectedRecipe.asStateFlow()

    fun updateProfile(gender: Gender, age: Int, height: Float, weight: Float, goal: GoalType) {
        val bmr = if (gender == Gender.MALE) {
            (10 * weight) + (6.25f * height) - (5 * age) + 5
        } else {
            (10 * weight) + (6.25f * height) - (5 * age) - 161
        }
        val tdee = bmr * 1.375f
        val target = when (goal) {
            GoalType.WEIGHT_LOSS -> (tdee - 400).toInt()
            GoalType.WEIGHT_GAIN -> (tdee + 400).toInt()
        }

        _userProfile.update {
            it.copy(
                gender = gender,
                age = age,
                height = height,
                weight = weight,
                goal = goal,
                targetCalories = target
            )
        }
    }

    fun addConsumedCalories(calories: Int) {
        _consumedCalories.update { it + calories }
    }

    fun toggleBookmark() {
        _selectedRecipe.update { it.copy(isBookmarked = !it.isBookmarked) }
    }

    fun toggleLike() {
        _selectedRecipe.update { it.copy(isLiked = !it.isLiked) }
    }
}
