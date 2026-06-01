import java.util.Properties

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use(keystoreProperties::load)
}

val environmentKeystorePath = System.getenv("ANDROID_KEYSTORE_PATH")
val hasEnvironmentSigning = !environmentKeystorePath.isNullOrBlank()
val hasFileSigning = keystorePropertiesFile.exists()
val hasReleaseSigning = hasEnvironmentSigning || hasFileSigning

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

// if (providers.gradleProperty("hms").orNull == "true") {
//     pluginManager.apply("com.huawei.agconnect")
// }

android {
    namespace = "ru.bag24.storage"
    compileSdk = 37
    ndkVersion = "29.0.14206865"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "ru.bag24.storage"
        minSdk = 28
        targetSdk = 37
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasEnvironmentSigning) {
                keyAlias = System.getenv("ANDROID_KEYSTORE_ALIAS")
                keyPassword = System.getenv("ANDROID_KEYSTORE_PRIVATE_KEY_PASSWORD")
                storeFile = file(requireNotNull(environmentKeystorePath))
                storePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD")
            } else if (hasFileSigning) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(requireNotNull(keystoreProperties.getProperty("storeFile")))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    flavorDimensions += "default"
    productFlavors {
        create("development") {
            dimension = "default"
            applicationIdSuffix = ".dev"
            manifestPlaceholders["appName"] = "[DEV] BAG24"
        }
        create("production") {
            dimension = "default"
            manifestPlaceholders["appName"] = "BAG24"
        }
        create("staging") {
            dimension = "default"
            applicationIdSuffix = ".stage"
            manifestPlaceholders["appName"] = "[STG] BAG24"
        }
    }

    buildTypes {
        getByName("debug") {
            if (hasReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            }
            isMinifyEnabled = true
        }
        getByName("release") {
            signingConfig =
                if (hasReleaseSigning) {
                    signingConfigs.getByName("release")
                } else {
                    signingConfigs.getByName("debug")
                }
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    // if (providers.gradleProperty("hms").orNull == "true") {
    //     implementation("com.huawei.agconnect:agconnect-core:1.9.1.303")
    // }
}
