import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.gradle.api.JavaVersion
import org.gradle.api.tasks.compile.JavaCompile
import com.android.build.gradle.BaseExtension // 🚨 NEW: Directly imports the Android engine

allprojects {
    repositories {
        google()
        mavenCentral()
    }

    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = "17"
        targetCompatibility = "17"
    }

    tasks.withType<KotlinCompile>().configureEach {
        compilerOptions.jvmTarget.set(JvmTarget.JVM_17)
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// 🚨 THE CLEAN OVERRIDE SCRIPT 🚨
subprojects {
    afterEvaluate {
        // We stop guessing and cast directly to the true Android extension
        val androidExt = extensions.findByName("android") as? BaseExtension
        
        if (androidExt != null) {
            
            // 1. Force Compile SDK to 36 (This permanently fixes the Isar lStar crash)
            androidExt.compileSdkVersion(36)

            // 2. Fix Isar Missing Namespace
            if (androidExt.namespace == null || androidExt.namespace!!.isEmpty()) {
                var targetNamespace = project.group.toString()
                if (targetNamespace.isEmpty()) {
                    targetNamespace = "com.example." + project.name.replace("-", "_")
                }
                androidExt.namespace = targetNamespace
            }

            // 3. Force Java 17 internally for all plugins
            androidExt.compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}