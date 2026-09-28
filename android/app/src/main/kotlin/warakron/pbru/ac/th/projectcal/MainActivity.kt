package warakron.pbru.ac.th.projectcal

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.lifecycle.viewmodel.compose.viewModel
import warakron.pbru.ac.th.projectcal.ui.navigation.HealthNavGraph
import warakron.pbru.ac.th.projectcal.ui.theme.HealthDietAppTheme
import warakron.pbru.ac.th.projectcal.viewmodel.HealthViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            HealthDietAppTheme {
                val viewModel: HealthViewModel = viewModel()
                HealthNavGraph(viewModel = viewModel)
            }
        }
    }
}
