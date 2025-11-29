# Flutter-specific ProGuard rules

# Keep Flutter framework classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep model classes
-keep class com.example.pakida.models.** { *; }

# Google Play Core Library - essential classes only
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

# Maximum optimization
-optimizationpasses 9
-allowaccessmodification
-mergeinterfacesaggressively
-overloadaggressively

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Remove unused resources
-dontwarn com.google.android.play.core.**
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
