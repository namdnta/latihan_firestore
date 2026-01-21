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
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
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