package warakron.pbru.ac.th.projectcal.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import warakron.pbru.ac.th.projectcal.data.MealItem
import warakron.pbru.ac.th.projectcal.data.MealType
import warakron.pbru.ac.th.projectcal.ui.theme.*
import warakron.pbru.ac.th.projectcal.viewmodel.HealthViewModel

@Composable
fun DailyMealPlannerScreen(
    viewModel: HealthViewModel,
    onNavigateToRecipe: () -> Unit,
    onNavigateBack: () -> Unit
) {
    val profile by viewModel.userProfile.collectAsState()
    val consumed by viewModel.consumedCalories.collectAsState()
    val meals by viewModel.dailyMeals.collectAsState()

    var selectedBottomNav by remember { mutableIntStateOf(0) }

    Scaffold(
        bottomBar = {
            NavigationBar(
                containerColor = SurfaceWhite,
                tonalElevation = 8.dp
            ) {
                NavigationBarItem(
                    icon = { Icon(Icons.Default.Home, contentDescription = "หน้าหลัก") },
                    label = { Text("หน้าหลัก") },
                    selected = selectedBottomNav == 0,
                    onClick = { selectedBottomNav = 0 }
                )
                NavigationBarItem(
                    icon = { Icon(Icons.Default.RestaurantMenu, contentDescription = "แผนอาหาร") },
                    label = { Text("แผนอาหาร") },
                    selected = selectedBottomNav == 1,
                    onClick = { selectedBottomNav = 1 }
                )
                NavigationBarItem(
                    icon = { Icon(Icons.Default.Favorite, contentDescription = "รายการโปรด") },
                    label = { Text("รายการโปรด") },
                    selected = selectedBottomNav == 2,
                    onClick = { selectedBottomNav = 2 }
                )
                NavigationBarItem(
                    icon = { Icon(Icons.Default.Person, contentDescription = "โปรไฟล์") },
                    label = { Text("โปรไฟล์") },
                    selected = selectedBottomNav == 3,
                    onClick = { selectedBottomNav = 3; onNavigateBack() }
                )
            }
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(MaterialTheme.colorScheme.background)
                .verticalScroll(rememberScrollState())
                .padding(paddingValues)
                .padding(20.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text(text = "สวัสดี, คุณรักสุขภาพ 👋", fontSize = 18.sp, fontWeight = FontWeight.Bold)
                    Text(text = "แผนโภชนาการประจำวันของคุณ", fontSize = 13.sp, color = TextSecondary)
                }
                IconButton(onClick = onNavigateBack) {
                    Icon(Icons.Default.Settings, contentDescription = "ตั้งค่าเป้าหมาย")
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(24.dp),
                colors = CardDefaults.cardColors(containerColor = MossGreenPrimary)
            ) {
                Column(
                    modifier = Modifier.padding(20.dp),
                    horizontalAlignment = Alignment.CenterVertically
                ) {
                    Text(text = "เป้าหมายวันนี้: ${profile.targetCalories} kcal", color = SurfaceWhite.copy(alpha = 0.8f), fontSize = 14.sp)
                    Spacer(modifier = Modifier.height(12.dp))

                    Box(
                        modifier = Modifier.size(130.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        CircularProgressIndicator(
                            progress = { consumed.toFloat() / profile.targetCalories.toFloat() },
                            modifier = Modifier.fillMaxSize(),
                            color = PastelOrange,
                            trackColor = SurfaceWhite.copy(alpha = 0.2f),
                            strokeWidth = 10.dp,
                        )
                        Column(horizontalAlignment = Alignment.CenterVertically) {
                            Text(text = "$consumed", fontSize = 28.sp, fontWeight = FontWeight.Bold, color = SurfaceWhite)
                            Text(text = "ทานไป (kcal)", fontSize = 11.sp, color = SurfaceWhite.copy(alpha = 0.8f))
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceAround
                    ) {
                        MacroBadge(label = "คาร์บ", value = "165g", color = PastelOrange)
                        MacroBadge(label = "โปรตีน", value = "95g", color = Color(0xFF64B5F6))
                        MacroBadge(label = "ไขมัน", value = "45g", color = Color(0xFFFFD54F))
                    }
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            MealSectionHeader(title = "มื้อเช้า (Breakfast)", recommendedKcal = "350 kcal", onSwapClick = {})
            Spacer(modifier = Modifier.height(8.dp))
            MealCard(meal = meals[0], onClick = onNavigateToRecipe)

            Spacer(modifier = Modifier.height(16.dp))

            MealSectionHeader(title = "มื้อกลางวัน (Lunch)", recommendedKcal = "520 kcal", onSwapClick = {})
            Spacer(modifier = Modifier.height(8.dp))
            MealCard(meal = meals[1], onClick = onNavigateToRecipe)

            Spacer(modifier = Modifier.height(16.dp))

            MealSectionHeader(title = "มื้อเย็น (Dinner)", recommendedKcal = "400 kcal", onSwapClick = {})
            Spacer(modifier = Modifier.height(8.dp))
            MealCard(meal = meals[2], onClick = onNavigateToRecipe)
        }
    }
}

@Composable
fun MacroBadge(label: String, value: String, color: Color) {
    Column(
        modifier = Modifier
            .clip(RoundedCornerShape(12.dp))
            .background(SurfaceWhite.copy(alpha = 0.15f))
            .padding(horizontal = 14.dp, vertical = 8.dp),
        horizontalAlignment = Alignment.CenterVertically
    ) {
        Text(text = label, fontSize = 12.sp, color = SurfaceWhite.copy(alpha = 0.8f))
        Text(text = value, fontSize = 14.sp, fontWeight = FontWeight.Bold, color = SurfaceWhite)
    }
}

@Composable
fun MealSectionHeader(title: String, recommendedKcal: String, onSwapClick: () -> Unit) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column {
            Text(text = title, fontSize = 16.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
            Text(text = "แนะนำ: $recommendedKcal", fontSize = 12.sp, color = TextSecondary)
        }
        TextButton(onClick = onSwapClick) {
            Text(text = "สลับเมนูอื่น", fontSize = 12.sp, color = PastelOrange, fontWeight = FontWeight.Bold)
        }
    }
}

@Composable
fun MealCard(meal: MealItem, onClick: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() },
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = SurfaceWhite),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(60.dp)
                    .clip(CircleShape)
                    .background(SurfaceTintGreen),
                contentAlignment = Alignment.Center
            ) {
                Text("🍲", fontSize = 28.sp)
            }

            Spacer(modifier = Modifier.width(16.dp))

            Column(modifier = Modifier.weight(1f)) {
                Text(text = meal.title, fontSize = 15.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
                Spacer(modifier = Modifier.height(4.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text(text = "${meal.calories} Kcal", fontSize = 13.sp, color = PastelOrange, fontWeight = FontWeight.Bold)
                    Text(text = "•", fontSize = 13.sp, color = TextSecondary)
                    Text(text = "โปรตีน ${meal.protein.toInt()}g", fontSize = 13.sp, color = TextSecondary)
                }
            }

            Icon(
                imageVector = Icons.Default.ChevronRight,
                contentDescription = null,
                tint = TextSecondary
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun DailyMealPlannerPreview() {
    HealthDietAppTheme {
        DailyMealPlannerScreen(viewModel = HealthViewModel(), onNavigateToRecipe = {}, onNavigateBack = {})
    }
}
