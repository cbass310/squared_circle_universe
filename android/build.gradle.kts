import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.gradle.api.JavaVersion

allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // Force Kotlin to 11 to satisfy modern plugins
    tasks.withType<KotlinCompile>().configureEach {
        compilerOptions.jvmTarget.set(JvmTarget.JVM_11)
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// 🚨 REGISTER OVERRIDES BEFORE EVALUATING 🚨
subprojects {
    project.afterEvaluate {
        if (project.hasProperty("android")) {
            val androidExt = project.extensions.findByName("android")
            if (androidExt != null) {
                
                // 1. Isar Database Namespace Fix
                val getNamespace = androidExt.javaClass.methods.find { it.name == "getNamespace" }
                val setNamespace = androidExt.javaClass.methods.find { it.name == "setNamespace" }
                if (getNamespace != null && setNamespace != null) {
                    val currentNamespace = getNamespace.invoke(androidExt)
                    if (currentNamespace == null) {
                        var targetNamespace = project.group.toString()
                        if (targetNamespace.isEmpty()) targetNamespace = "com.example." + project.name.replace("-", "_")
                        setNamespace.invoke(androidExt, targetNamespace)
                    }
                }

                // 2. Audioplayers Java 1.8 -> 11 Fix
                val compileOptions = androidExt.javaClass.methods.find { it.name == "getCompileOptions" }?.invoke(androidExt)
                if (compileOptions != null) {
                    val setSource = compileOptions.javaClass.methods.find { it.name == "setSourceCompatibility" }
                    val setTarget = compileOptions.javaClass.methods.find { it.name == "setTargetCompatibility" }
                    setSource?.invoke(compileOptions, JavaVersion.VERSION_11)
                    setTarget?.invoke(compileOptions, JavaVersion.VERSION_11)
                }

                // 3. 🚨 NEW FIX: Force Compile SDK to 34 for sign_in_with_apple
                try {
                    val setCompileSdk = androidExt.javaClass.methods.find { 
                        (it.name == "setCompileSdkVersion" || it.name == "compileSdkVersion") && 
                        it.parameterCount == 1 
                    }
                    setCompileSdk?.invoke(androidExt, 34)
                } catch (e: Exception) {
                    // Ignore if the plugin doesn't support it
                }
            }
        }
    }
}

// Force evaluation AFTER the hooks are in place!
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}