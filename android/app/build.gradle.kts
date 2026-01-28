plugins {
    id("com.android.application")
    id("kotlin-android")
    // 1. Tambahkan plugin Google Services di sini
    id("com.google.gms.google-services")
    // Flutter plugin harus tetap di bawah
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.latihan_firestore"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Use Java 17 to align with modern AGP/Flutter toolchains
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        // Match Kotlin JVM target to Java version
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.latihan_firestore"
        // Untuk Firebase/Firestore, biasanya disarankan minSdk minimal 21 atau 23
        // Jika flutter.minSdkVersion terlalu rendah, Anda bisa manual set ke 21
        minSdk = flutter.minSdkVersion 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Di Flutter, dependensi Firebase biasanya diatur di 'pubspec.yaml'.
    // Namun, platform BoM tetap bisa ditambahkan untuk memastikan kompatibilitas versi native.
    implementation(platform("com.google.firebase:firebase-bom:33.1.0"))
}