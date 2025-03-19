allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Переопределение buildDir проекта
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get().asFile
rootProject.buildDir = newBuildDir

subprojects {
    // Установка buildDir для всех подпроектов
    buildDir = File(rootProject.buildDir, name)

    // Фикс для verifyReleaseResources и namespace
    afterEvaluate {
        plugins.withId("com.android.application") {
            extensions.configure<com.android.build.gradle.AppExtension>("android") {
                compileSdkVersion(35)
                buildToolsVersion("35.0.0")
            }
        }

        plugins.withId("com.android.library") {
            extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
                compileSdkVersion(35)
                buildToolsVersion("35.0.0")
            }
        }

        if (project.extensions.findByName("android") != null) {
            val androidExtension = extensions.getByName("android")
            val namespaceProperty = androidExtension::class.members.find { it.name == "namespace" }
            if (namespaceProperty == null) {
                // Устанавливаем namespace, если он не задан
                androidExtension::class.members.find { it.name == "setNamespace" }?.call(androidExtension, project.group.toString())
            }
        }
    }

    evaluationDependsOn(":app")
}

// Задача clean
tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}