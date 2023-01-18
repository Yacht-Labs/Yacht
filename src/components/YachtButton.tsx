import React, { useEffect, useRef } from "react";
import { View, StyleSheet, Text, TouchableOpacity, StyleProp, ViewStyle, Animated } from "react-native";


interface YachtButtonProps {
    onPress: () => Promise<void>,
    title: string,
    style: StyleProp<ViewStyle>,
    disabled: boolean,
    fetching: boolean
}

export default function YachtButton({ onPress, title, style, disabled, fetching }: YachtButtonProps) {
    const animatedValue = useRef(new Animated.Value(0)).current;
    const scale = animatedValue.interpolate({inputRange: [0, 1], outputRange: [1, .9]});
    const pulse = () => {
        const animation = Animated.loop(Animated.sequence([
            Animated.timing(animatedValue, {
                toValue: 1, 
                duration: 1000,
                useNativeDriver: true
            }),
            Animated.timing(animatedValue, {
                toValue: 0, 
                duration: 1000,
                useNativeDriver: true
            }),
        ]));
        return animation;
    }

    // const animation = useSharedValue(0);
    // const pulse = () => {
    //     animation.value = withRepeat(
    //         withTiming(1, {
    //             duration: 2000,
    //             easing: Easing.linear
    //         }),
    //         1,true
    //     )
    // }

    useEffect(() => {
        return fetching ? pulse().start() : pulse().stop();
    }, [fetching])
    
    // const animatedStyles = useAnimatedStyle(() => {
    //     const scale = interpolate(animation.value, [0, 1], [1, 1.1],Extrapolation.CLAMP)
    //     return {
    //         transform: [{scale}],
    //     }
    // })
    return (
        <TouchableOpacity 
            onPress={onPress}
            disabled={disabled || fetching} 
            activeOpacity={0.8} >
            <Animated.View style={[style, styles.buttonContainer, disabled && {backgroundColor: 'gray'}, fetching && {transform: [{scale}]}]}>
                <Text style={styles.buttonText}>{title}</Text>
            </Animated.View>
        </TouchableOpacity>
    );
}

const styles = StyleSheet.create({
    buttonText: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 18,
        color: 'white',
        textAlign: 'center'
    },
    buttonContainer: {
        justifyContent: 'center',
        elevation: 8,
        borderRadius: 10,
        paddingVertical: 10,
        paddingHorizontal: 12
      },
});