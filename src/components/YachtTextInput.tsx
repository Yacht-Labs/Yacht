import React from "react";
import { View, StyleSheet, Text, TextInput } from "react-native";

export default function YachtTextInput({ label, onChangeText, style }) {
    return (
        <View style={style}>
            <Text style={styles.label}>{label}</Text>
            <TextInput  style={styles.input}
                        onChangeText={onChangeText} />
        </View>
    );
};

const styles = StyleSheet.create({
    label: {
        fontFamily: 'Akkurat',
        fontSize: 14,
        paddingBottom: 6
    },
    input: {
        height: 40,
        borderWidth: 1,
        borderRadius: 5,
    }
});