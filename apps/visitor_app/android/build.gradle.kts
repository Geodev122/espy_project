plugins {
    id("com.android.application") version "8.7.0" apply false
    id("com.android.library") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "2.1.10" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    afterEvaluate {
        if (project.extensions.findByName("android") != null) {
            configure<com.android.build.gradle.BaseExtension> {
                compileSdkVersion(36)
                ndkVersion = "25.1.8937393"
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
