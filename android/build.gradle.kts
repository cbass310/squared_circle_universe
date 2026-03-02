import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.gradle.api.tasks.compile.JavaCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // 🚨 FORCE JAVA TO 17 🚨
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = "17"
        targetCompatibility = "17"
    }

    // 🚨 FORCE KOTLIN TO 17 🚨
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

// THE ISAR NAMESPACE OVERRIDE 
subprojects {
    afterEvaluate {
        if (hasProperty("android")) {
            val androidExt = extensions.findByName("android")
            if (androidExt != null) {
                try {
                    val getNamespace = androidExt.javaClass.getMethod("getNamespace")
                    val currentNamespace = getNamespace.invoke(androidExt)
                    if (currentNamespace == null || currentNamespace.toString().isEmpty()) {
                        val setNamespace = androidExt.javaClass.getMethod("setNamespace", String::class.java)
                        var targetNamespace = project.group.toString()
                        if (targetNamespace.isEmpty()) {
                            targetNamespace = "com.example." + project.name.replace("-", "_")
                        }
                        setNamespace.invoke(androidExt, targetNamespace)
                    }
                } catch (e: Exception) {
                    // Ignore if methods don't exist
                }
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