package warakron.pbru.ac.th.projectcal.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable

private val LightColorScheme = lightColorScheme(
    primary = MossGreenPrimary,
    onPrimary = SurfaceWhite,
    secondary = PastelOrange,
    onSecondary = SurfaceWhite,
    background = LightBackground,
    surface = SurfaceWhite,
    onSurface = TextPrimary,
    onSurfaceVariant = TextSecondary,
    surfaceVariant = SurfaceTintGreen
)

@Composable
fun HealthDietAppTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = LightColorScheme,
        typography = androidx.compose.material3.Typography(),
        shapes = AppShapes,
        content = content
    )
}
