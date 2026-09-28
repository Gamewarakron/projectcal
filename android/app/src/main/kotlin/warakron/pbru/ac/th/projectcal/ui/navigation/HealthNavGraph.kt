package warakron.pbru.ac.th.projectcal.ui.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import warakron.pbru.ac.th.projectcal.ui.screens.DailyMealPlannerScreen
import warakron.pbru.ac.th.projectcal.ui.screens.GoalCalculatorScreen
import warakron.pbru.ac.th.projectcal.ui.screens.RecipeDetailScreen
import warakron.pbru.ac.th.projectcal.viewmodel.HealthViewModel

sealed class Screen(val route: String) {
    object GoalCalculator : Screen("goal_calculator")
    object MealPlanner : Screen("meal_planner")
    object RecipeDetail : Screen("recipe_detail")
}

@Composable
fun HealthNavGraph(viewModel: HealthViewModel) {
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = Screen.GoalCalculator.route
    ) {
        composable(Screen.GoalCalculator.route) {
            GoalCalculatorScreen(
                viewModel = viewModel,
                onNavigateToPlanner = {
                    navController.navigate(Screen.MealPlanner.route) {
                        popUpTo(Screen.GoalCalculator.route) { inclusive = true }
                    }
                }
            )
        }
        composable(Screen.MealPlanner.route) {
            DailyMealPlannerScreen(
                viewModel = viewModel,
                onNavigateToRecipe = {
                    navController.navigate(Screen.RecipeDetail.route)
                },
                onNavigateBack = {
                    navController.popBackStack()
                }
            )
        }
        composable(Screen.RecipeDetail.route) {
            RecipeDetailScreen(
                viewModel = viewModel,
                onBackClick = {
                    navController.popBackStack()
                }
            )
        }
    }
}
