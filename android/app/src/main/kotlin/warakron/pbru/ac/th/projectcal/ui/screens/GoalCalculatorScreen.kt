package warakron.pbru.ac.th.projectcal.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.TrendingDown
import androidx.compose.material.icons.filled.TrendingUp
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import warakron.pbru.ac.th.projectcal.data.Gender
import warakron.pbru.ac.th.projectcal.data.GoalType
import warakron.pbru.ac.th.projectcal.ui.theme.*
import warakron.pbru.ac.th.projectcal.viewmodel.HealthViewModel

@Composable
fun GoalCalculatorScreen(
    viewModel: HealthViewModel,
    onNavigateToPlanner: () -> Unit
) {
    val profile by viewModel.userProfile.collectAsState()

    var gender by remember { mutableStateOf(profile.gender) }
    var ageText by remember { mutableStateOf(profile.age.toString()) }
    var heightText by remember { mutableStateOf(profile.height.toString()) }
    var weightText by remember { mutableStateOf(profile.weight.toString()) }
    var selectedGoal by remember { mutableStateOf(profile.goal) }

    Surface(
        modifier = Modifier.fillMaxSize(),
        color = MaterialTheme.colorScheme.background
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(20.dp)
        ) {
            // Header
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text(
                        text = "เริ่มต้นดูแลสุขภาพของคุณวันนี้",
                        fontSize = 20.sp,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.onSurface
                    )
                    Text(
                        text = "กรอกข้อมูลเพื่อคำนวณพลังงานที่เหมาะสม",
                        fontSize = 14.sp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
                Box(
                    modifier = Modifier
                        .size(48.dp)
                        .clip(CircleShape)
                        .background(SurfaceTintGreen),
                    contentAlignment = Alignment.Center
                ) {
                    Text("👤", fontSize = 22.sp)
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Form Input Card
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(20.dp),
                colors = CardDefaults.cardColors(containerColor = SurfaceWhite),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
            ) {
                Column(modifier = Modifier.padding(20.dp)) {
                    Text(
                        text = "ข้อมูลส่วนตัว",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        color = MossGreenPrimary
                    )
                    Spacer(modifier = Modifier.height(16.dp))

                    // Gender Selection
                    Text("เพศ", fontSize = 14.sp, color = TextSecondary)
                    Spacer(modifier = Modifier.height(8.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        GenderButton(
                            title = "ชาย",
                            isSelected = gender == Gender.MALE,
                            modifier = Modifier.weight(1f)
                        ) { gender = Gender.MALE }

                        GenderButton(
                            title = "หญิง",
                            isSelected = gender == Gender.FEMALE,
                            modifier = Modifier.weight(1f)
                        ) { gender = Gender.FEMALE }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    OutlinedTextField(
                        value = ageText,
                        onValueChange = { ageText = it },
                        label = { Text("อายุ (ปี)") },
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(12.dp)
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    OutlinedTextField(
                        value = heightText,
                        onValueChange = { heightText = it },
                        label = { Text("ส่วนสูง (ซม.)") },
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(12.dp)
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    OutlinedTextField(
                        value = weightText,
                        onValueChange = { weightText = it },
                        label = { Text("น้ำหนักปัจจุบัน (กก.)") },
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(12.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Goal Selection Cards
            Text(
                text = "เป้าหมายของคุณ",
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onSurface
            )
            Spacer(modifier = Modifier.height(12.dp))

            GoalCard(
                title = "ลดน้ำหนัก",
                subtitle = "ลด 300-500 kcal จาก TDEE",
                icon = Icons.Default.TrendingDown,
                isMint = true,
                isSelected = selectedGoal == GoalType.WEIGHT_LOSS
            ) {
                selectedGoal = GoalType.WEIGHT_LOSS
            }

            Spacer(modifier = Modifier.height(12.dp))

            GoalCard(
                title = "เพิ่มน้ำหนัก / สร้างกล้ามเนื้อ",
                subtitle = "เพิ่ม 300-500 kcal จาก TDEE",
                icon = Icons.Default.TrendingUp,
                isMint = false,
                isSelected = selectedGoal == GoalType.WEIGHT_GAIN
            ) {
                selectedGoal = GoalType.WEIGHT_GAIN
            }

            Spacer(modifier = Modifier.height(28.dp))

            Button(
                onClick = {
                    val age = ageText.toIntOrNull() ?: 25
                    val height = heightText.toFloatOrNull() ?: 165f
                    val weight = weightText.toFloatOrNull() ?: 60f
                    viewModel.updateProfile(gender, age, height, weight, selectedGoal)
                    onNavigateToPlanner()
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp),
                shape = RoundedCornerShape(28.dp),
                colors = ButtonDefaults.buttonColors(containerColor = MossGreenPrimary)
            ) {
                Text(
                    text = "คำนวณและจัดมื้ออาหาร",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    color = SurfaceWhite
                )
            }
        }
    }
}

@Composable
fun GenderButton(title: String, isSelected: Boolean, modifier: Modifier = Modifier, onClick: () -> Unit) {
    val borderColor = if (isSelected) MossGreenPrimary else Color.LightGray
    val bgColor = if (isSelected) SurfaceTintGreen else SurfaceWhite
    val textColor = if (isSelected) MossGreenPrimary else TextSecondary

    Box(
        modifier = modifier
            .height(48.dp)
            .clip(RoundedCornerShape(12.dp))
            .background(bgColor)
            .border(1.5.dp, borderColor, RoundedCornerShape(12.dp))
            .clickable { onClick() },
        contentAlignment = Alignment.Center
    ) {
        Text(text = title, fontWeight = FontWeight.Bold, color = textColor)
    }
}

@Composable
fun GoalCard(
    title: String,
    subtitle: String,
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    isMint: Boolean,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    val bgCard = if (isMint) MintCardBg else OrangeCardBg
    val accentColor = if (isMint) MossGreenPrimary else PastelOrange
    val borderColor = if (isSelected) accentColor else Color.Transparent

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .border(2.dp, borderColor, RoundedCornerShape(16.dp))
            .clickable { onClick() },
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = bgCard)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(44.dp)
                    .clip(CircleShape)
                    .background(accentColor.copy(alpha = 0.2f)),
                contentAlignment = Alignment.Center
            ) {
                Icon(imageVector = icon, contentDescription = null, tint = accentColor)
            }
            Spacer(modifier = Modifier.width(16.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(text = title, fontWeight = FontWeight.Bold, fontSize = 15.sp, color = TextPrimary)
                Text(text = subtitle, fontSize = 13.sp, color = TextSecondary)
            }
            if (isSelected) {
                Icon(imageVector = Icons.Default.CheckCircle, contentDescription = null, tint = accentColor)
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun GoalCalculatorScreenPreview() {
    HealthDietAppTheme {
        GoalCalculatorScreen(viewModel = HealthViewModel(), onNavigateToPlanner = {})
    }
}
