import React, { useState } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import CreateLitSwapView from '../views/CreateLitSwapView';
import SendTokensToSwap from '../views/SendTokensToSwap';
import CompleteSwap from '../views/CompleteSwap';
import { SwapContextProvider } from '../context/SwapContext';
import MySwaps from '../views/MySwaps';

const Stack = createNativeStackNavigator();

export default function LitSwapNavigator() {

    return(
        <SwapContextProvider>
            <NavigationContainer>
                <Stack.Navigator
                    screenOptions={{
                        headerLargeTitle: true,
                        headerLargeTitleStyle: {
                            fontFamily: 'Bookmania',
                            fontSize: 28
                        },
                        contentStyle: {
                            backgroundColor: 'white'
                        },
                        headerTransparent: true
                }}> 
                    <Stack.Screen name="Create Lit Swap" component={CreateLitSwapView} />
                    <Stack.Screen name="New Lit Yacht Swap" component={CreateLitSwapView} />
                    <Stack.Screen name="Send Tokens To Swap" component={SendTokensToSwap} />
                    <Stack.Screen name="Complete Swap" component={CompleteSwap} />
                </Stack.Navigator>
            </NavigationContainer>
        </SwapContextProvider>
    );
};

// <Stack.Screen name="My Swaps" component={MySwaps} />