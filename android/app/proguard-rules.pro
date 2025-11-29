# Maximum optimization for minimum APK size
-optimizationpasses 9
-allowaccessmodification
-mergeinterfacesaggressively
-overloadaggressively
-repackageclasses ''

# Keep only essential Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Google Play Core - minimal keep
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Remove all logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Remove debug info
-assumenosideeffects class kotlin.jvm.internal.Intrinsics {
    static void checkParameterIsNotNull(java.lang.Object, java.lang.String);
}

# Minimal enum keep
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Suppress warnings
-dontwarn com.google.android.play.core.**
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
-dontwarn kotlin.**
-dontwarn org.jetbrains.annotations.**
