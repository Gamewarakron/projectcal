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
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import warakron.pbru.ac.th.projectcal.data.Ingredient
import warakron.pbru.ac.th.projectcal.ui.theme.*
import warakron.pbru.ac.th.projectcal.viewmodel.HealthViewModel

@Composable
fun RecipeDetailScreen(
    viewModel: HealthViewModel,
    onBackClick: () -> Unit
) {
    val recipe by viewModel.selectedRecipe.collectAsState()
    var ingredientsState by remember { mutableStateOf(recipe.ingredients) }

    Scaffold(
        bottomBar = {
            Surface(
                modifier = Modifier.fillMaxWidth(),
                color = SurfaceWhite,
                shadowElevation = 8.dp
            ) {
                Box(modifier = Modifier.padding(16.dp)) {
                    Button(
                        onClick = {
                            viewModel.addConsumedCalories(recipe.calories)
                            onBackClick()
                        },
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(54.dp),
                        shape = RoundedCornerShape(27.dp),
                        colors = ButtonDefaults.buttonColors(containerColor = MossGreenPrimary)
                    ) {
                        Text(
                            text = "ทานมื้อนี้แล้ว (+${recipe.calories} kcal)",
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold,
                            color = SurfaceWhite
                        )
                    }
                }
            }
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(MaterialTheme.colorScheme.background)
                .verticalScroll(rememberScrollState())
                .padding(paddingValues)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(280.dp)
            ) {
                AsyncImage(
                    model = recipe.imageUrl,
                    contentDescription = recipe.title,
                    modifier = Modifier.fillMaxSize(),
                    contentScale = ContentScale.Crop
                )

                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .background(Color.Black.copy(alpha = 0.2f))
                )

                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    IconButton(
                        onClick = onBackClick,
                        modifier = Modifier
                            .clip(CircleShape)
                            .background(SurfaceWhite.copy(alpha = 0.8f))
                    ) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "ย้อนกลับ", tint = TextPrimary)
                    }

                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        IconButton(
                            onClick = { viewModel.toggleBookmark() },
                            modifier = Modifier
                                .clip(CircleShape)
                                .background(SurfaceWhite.copy(alpha = 0.8f))
                        ) {
                            Icon(
                                imageVector = if (recipe.isBookmarked) Icons.Default.Bookmark else Icons.Default.BookmarkBorder,
                                contentDescription = "บันทึก",
                                tint = if (recipe.isBookmarked) PastelOrange else TextPrimary
                            )
                        }

                        IconButton(
                            onClick = { viewModel.toggleLike() },
                            modifier = Modifier
                                .clip(CircleShape)
                                .background(SurfaceWhite.copy(alpha = 0.8f))
                        ) {
                            Icon(
                                imageVector = if (recipe.isLiked) Icons.Default.Favorite else Icons.Default.FavoriteBorder,
                                contentDescription = "ถูกใจ",
                                tint = if (recipe.isLiked) Color.Red else TextPrimary
                            )
                        }
                    }
                }
            }

            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .offset(y = (-20).dp)
                    .clip(RoundedCornerShape(topStart = 24.dp, topEnd = 24.dp))
                    .background(SurfaceWhite)
                    .padding(20.dp)
            ) {
                Text(
                    text = recipe.title,
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Bold,
                    color = TextPrimary
                )

                Spacer(modifier = Modifier.height(12.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    InfoTag(icon = "🔥", text = "${recipe.calories} Kcal")
                    InfoTag(icon = "⏱️", text = "${recipe.prepTimeMinutes} นาที")
                    InfoTag(icon = "⭐", text = recipe.difficulty)
                }

                Spacer(modifier = Modifier.height(16.dp))

                HorizontalDivider(color = Color.LightGray.copy(alpha = 0.5f))

                Spacer(modifier = Modifier.height(16.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceAround
                ) {
                    NutritionItem(label = "โปรตีน", value = "${recipe.protein.toInt()}g")
                    NutritionItem(label = "คาร์โบไฮเดรต", value = "${recipe.carbs.toInt()}g")
                    NutritionItem(label = "ไขมัน", value = "${recipe.fat.toInt()}g")
                }

                Spacer(modifier = Modifier.height(24.dp))

                Text(
                    text = "ส่วนผสม (Ingredients)",
                    fontSize = 17.sp,
                    fontWeight = FontWeight.Bold,
                    color = MossGreenPrimary
                )
                Spacer(modifier = Modifier.height(8.dp))

                ingredientsState.forEachIndexed { index, ingredient ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 6.dp)
                            .clickable {
                                ingredientsState = ingredientsState.toMutableList().also {
                                    it[index] = ingredient.copy(isChecked = !ingredient.isChecked)
                                }
                            },
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Checkbox(
                            checked = ingredient.isChecked,
                            onCheckedChange = { checked ->
                                ingredientsState = ingredientsState.toMutableList().also {
                                    it[index] = ingredient.copy(isChecked = checked)
                                }
                            },
                            colors = CheckboxDefaults.colors(checkedColor = MossGreenPrimary)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            text = "${ingredient.name} - ${ingredient.amount}",
                            fontSize = 14.sp,
                            color = if (ingredient.isChecked) TextSecondary else TextPrimary
                        )
                    }
                }

                Spacer(modifier = Modifier.height(24.dp))

                Text(
                    text = "ขั้นตอนการทำ (Steps)",
                    fontSize = 17.sp,
                    fontWeight = FontWeight.Bold,
                    color = MossGreenPrimary
                )
                Spacer(modifier = Modifier.height(12.dp))

                recipe.steps.forEach { step ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(bottom = 16.dp),
                        verticalAlignment = Alignment.Top
                    ) {
                        Box(
                            modifier = Modifier
                                .size(30.dp)
                                .clip(CircleShape)
                                .background(SurfaceTintGreen),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = "${step.stepNumber}",
                                fontWeight = FontWeight.Bold,
                                color = MossGreenPrimary,
                                fontSize = 14.sp
                            )
                        }
                        Spacer(modifier = Modifier.width(16.dp))
                        Text(
                            text = step.description,
                            fontSize = 14.sp,
                            color = TextPrimary,
                            modifier = Modifier
                                .weight(1f)
                                .padding(top = 4.dp)
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun InfoTag(icon: String, text: String) {
    Row(
        modifier = Modifier
            .clip(RoundedCornerShape(10.dp))
            .background(SurfaceTintGreen)
            .padding(horizontal = 12.dp, vertical = 6.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(text = icon, fontSize = 13.sp)
        Spacer(modifier = Modifier.width(6.dp))
        Text(text = text, fontSize = 13.sp, fontWeight = FontWeight.Bold, color = MossGreenPrimary)
    }
}

@Composable
fun NutritionItem(label: String, value: String) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Text(text = label, fontSize = 12.sp, color = TextSecondary)
        Spacer(modifier = Modifier.height(4.dp))
        Text(text = value, fontSize = 15.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
    }
}

@Preview(showBackground = true)
@Composable
fun RecipeDetailPreview() {
    HealthDietAppTheme {
        RecipeDetailScreen(viewModel = HealthViewModel(), onBackClick = {})
    }
}
