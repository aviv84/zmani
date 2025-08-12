plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.zmani" // !!! REPLACE com.example.zmani with YOUR ACTUAL PACKAGE NAME !!!
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.zmani" // !!! ALSO REPLACE THIS with YOUR ACTUAL PACKAGE NAME !!!
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = "1.8"
    }
    // If you are using Jetpack Compose, uncomment and configure these:
    // buildFeatures {
    //    compose = true
    // }
    // composeOptions {
    //    kotlinCompilerExtensionVersion = "1.5.8" // Use a version compatible with your Kotlin version
    // }
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    // implementation("androidx.activity:activity-compose:1.8.2") // If using Compose
    // implementation(platform("androidx.compose:compose-bom:2024.02.00")) // If using Compose BOM
    // implementation("androidx.compose.ui:ui") // If using Compose
    // implementation("androidx.compose.ui:ui-graphics") // If using Compose
    // implementation("androidx.compose.ui:ui-tooling-preview") // If using Compose
    // implementation("androidx.compose.material3:material3") // If using Compose Material3

    // Add your ZMANIM LIBRARY dependency here:
    // implementation("com.kosherjava:zmanim:2.6.0") // Or the version you were using

    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
    //androidTestImplementation(platform("androidx.compose:compose-bom:2024.02.00")) // If testing Compose
    //androidTestImplementation("androidx.compose.ui:ui-test-junit4") // If testing Compose
    //debugImplementation("androidx.compose.ui:ui-tooling") // If using Compose
    //debugImplementation("androidx.compose.ui:ui-test-manifest") // If using Compose
}
