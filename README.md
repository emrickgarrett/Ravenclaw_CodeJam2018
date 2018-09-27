# ravenclaw_codejam2018

Flutter Application that takes weather data to display information&#x2F;alerts for the user

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

## IDE Settings won't be uploaded
Shouldn't cause issues

## Build.gradle won't be updated
Will cause issues, if using work laptop adjust the code below in a file you create under the android folder (android/build.gradle)

```
buildscript {
    repositories {
        google()
        jcenter()
    }
     dependencies {
        classpath 'com.android.tools.build:gradle:3.1.2'
    }
}
 allprojects {
    repositories {
        google()
        jcenter()
    }
}
 rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}
 task clean(type: Delete) {
    delete rootProject.buildDir
}
```
