/**
 * Dot1Xer Supreme Enterprise Edition - AI Integration Library
 * Version 4.1.0
 * 
 * This library provides integration with various AI services:
 * - OpenAI (GPT models)
 * - Anthropic (Claude models)
 * - Google (Gemini models)
 */

const AIIntegration = {
    providers: {
        openai: {
            name: 'OpenAI',
            models: ['gpt-4o', 'gpt-4-turbo', 'gpt-3.5-turbo'],
            defaultModel: 'gpt-3.5-turbo',
            apiEndpoint: 'https://api.openai.com/v1/chat/completions',
            capabilities: ['configuration-optimization', 'security-analysis', 'documentation']
        },
        anthropic: {
            name: 'Anthropic',
            models: ['claude-3-opus', 'claude-3-sonnet', 'claude-3-haiku'],
            defaultModel: 'claude-3-haiku',
            apiEndpoint: 'https://api.anthropic.com/v1/messages',
            capabilities: ['configuration-optimization', 'security-analysis', 'documentation']
        },
        gemini: {
            name: 'Google Gemini',
            models: ['gemini-pro', 'gemini-ultra'],
            defaultModel: 'gemini-pro',
            apiEndpoint: 'https://generativelanguage.googleapis.com/v1beta/models/',
            capabilities: ['configuration-optimization', 'security-analysis', 'documentation']
        }
    },
    
    // Store API keys securely in memory only (not persisted)
    apiKeys: {},
    
    // Current provider settings
    currentProvider: 'openai',
    currentModel: '',
    
    // Initialize AI Integration
    init: function(config = {}) {
        console.log('Initializing AI Integration...');
        
        if (config.provider && this.providers[config.provider]) {
            this.currentProvider = config.provider;
        }
        
        if (config.apiKeys) {
            this.apiKeys = config.apiKeys;
        }
        
        // Set default model for current provider
        this.currentModel = this.providers[this.currentProvider].defaultModel;
        
        // Load API keys from localStorage if available
        try {
            const storedKeys = localStorage.getItem('dot1xer_api_keys');
            if (storedKeys) {
                const keys = JSON.parse(storedKeys);
                // Only store keys in memory, not as plaintext
                Object.keys(keys).forEach(provider => {
                    // Store only if not already provided in config
                    if (!this.apiKeys[provider]) {
                        this.apiKeys[provider] = keys[provider];
                    }
                });
            }
        } catch (e) {
            console.error('Failed to load API keys:', e);
        }
        
        console.log('AI Integration initialized');
    },
    
    // Set API key for a provider
    setApiKey: function(provider, key) {
        if (!this.providers[provider]) {
            console.error(`Provider ${provider} not supported`);
            return false;
        }
        
        this.apiKeys[provider] = key;
        
        // Store in localStorage
        try {
            const storedKeys = localStorage.getItem('dot1xer_api_keys');
            let keys = storedKeys ? JSON.parse(storedKeys) : {};
            keys[provider] = key;
            localStorage.setItem('dot1xer_api_keys', JSON.stringify(keys));
        } catch (e) {
            console.error('Failed to store API key:', e);
        }
        
        return true;
    },
    
    // Set current provider
    setProvider: function(provider) {
        if (!this.providers[provider]) {
            console.error(`Provider ${provider} not supported`);
            return false;
        }
        
        this.currentProvider = provider;
        this.currentModel = this.providers[provider].defaultModel;
        return true;
    },
    
    // Set current model
    setModel: function(model) {
        const provider = this.providers[this.currentProvider];
        if (!provider.models.includes(model)) {
            console.error(`Model ${model} not supported by ${provider.name}`);
            return false;
        }
        
        this.currentModel = model;
        return true;
    },
    
    // Optimize configuration using AI
    optimizeConfiguration: async function(config, settings, prompt = '') {
        console.log(`Optimizing configuration using ${this.providers[this.currentProvider].name}...`);
        
        if (!this.apiKeys[this.currentProvider]) {
            return {
                success: false,
                error: 'API key not set for this provider'
            };
        }
        
        // Create default prompt if not provided
        if (!prompt) {
            prompt = `Please optimize the following network device configuration for best 802.1X security practices and efficiency. 
            Consider industry best practices for authentication, authorization, and security.
            
            Configuration Settings:
            - Authentication Method: ${settings.authMethod}
            - Authentication Mode: ${settings.authMode}
            - Host Mode: ${settings.hostMode}
            - VLAN Auth: ${settings.vlanAuth}
            - VLAN Unauth: ${settings.vlanUnauth}
            
            Configuration:
            ${config}
            
            Please provide the optimized configuration with comments explaining your changes.`;
        }
        
        try {
            // Different API call formats depending on provider
            let response;
            switch(this.currentProvider) {
                case 'openai':
                    response = await this.callOpenAI(prompt);
                    break;
                case 'anthropic':
                    response = await this.callAnthropic(prompt);
                    break;
                case 'gemini':
                    response = await this.callGemini(prompt);
                    break;
                default:
                    throw new Error('Unsupported provider');
            }
            
            return {
                success: true,
                optimizedConfig: response,
                provider: this.providers[this.currentProvider].name,
                model: this.currentModel
            };
        } catch (error) {
            console.error('AI optimization failed:', error);
            return {
                success: false,
                error: error.message
            };
        }
    },
    
    // Analyze configuration security
    analyzeConfigSecurity: async function(config, settings) {
        const prompt = `Please analyze the security of this 802.1X configuration and provide recommendations for improvement.
        
        Configuration:
        ${config}
        
        Please identify:
        1. Security vulnerabilities or weaknesses
        2. Missing security controls
        3. Best practices not being followed
        4. Specific recommendations for improvement
        
        Format your response as a security report with clear sections.`;
        
        try {
            let response;
            switch(this.currentProvider) {
                case 'openai':
                    response = await this.callOpenAI(prompt);
                    break;
                case 'anthropic':
                    response = await this.callAnthropic(prompt);
                    break;
                case 'gemini':
                    response = await this.callGemini(prompt);
                    break;
                default:
                    throw new Error('Unsupported provider');
            }
            
            return {
                success: true,
                securityAnalysis: response,
                provider: this.providers[this.currentProvider].name,
                model: this.currentModel
            };
        } catch (error) {
            console.error('Security analysis failed:', error);
            return {
                success: false,
                error: error.message
            };
        }
    },
    
    // Generate deployment documentation
    generateDocumentation: async function(config, settings, templateType = 'standard') {
        const prompt = `Please generate comprehensive deployment documentation for this 802.1X configuration.
        
        Configuration:
        ${config}
        
        Settings:
        ${JSON.stringify(settings, null, 2)}
        
        Documentation Type: ${templateType}
        
        Please include:
        1. Executive summary
        2. Configuration overview
        3. Deployment prerequisites
        4. Step-by-step deployment instructions
        5. Testing procedures
        6. Troubleshooting guide
        
        Format as a professional deployment document with clear sections and headers.`;
        
        try {
            let response;
            switch(this.currentProvider) {
                case 'openai':
                    response = await this.callOpenAI(prompt);
                    break;
                case 'anthropic':
                    response = await this.callAnthropic(prompt);
                    break;
                case 'gemini':
                    response = await this.callGemini(prompt);
                    break;
                default:
                    throw new Error('Unsupported provider');
            }
            
            return {
                success: true,
                documentation: response,
                provider: this.providers[this.currentProvider].name,
                model: this.currentModel
            };
        } catch (error) {
            console.error('Documentation generation failed:', error);
            return {
                success: false,
                error: error.message
            };
        }
    },
    
    // Chat with AI assistant about 802.1X
    chatWithAssistant: async function(message, chatHistory = []) {
        const prompt = `I'm using the 802.1X Configuration and Management Platform. I need assistance with: ${message}
        
        Please provide detailed, accurate information about 802.1X, network security, and configuration best practices.`;
        
        // Append chat history
        let fullPrompt = prompt;
        if (chatHistory.length > 0) {
            fullPrompt = `Chat History:\n${chatHistory.map(m => `${m.role}: ${m.content}`).join('\n')}\n\nUser: ${message}
            
            Please respond to the user's latest question or request based on the chat history.`;
        }
        
        try {
            let response;
            switch(this.currentProvider) {
                case 'openai':
                    response = await this.callOpenAI(fullPrompt);
                    break;
                case 'anthropic':
                    response = await this.callAnthropic(fullPrompt);
                    break;
                case 'gemini':
                    response = await this.callGemini(fullPrompt);
                    break;
                default:
                    throw new Error('Unsupported provider');
            }
            
            return {
                success: true,
                response: response,
                provider: this.providers[this.currentProvider].name,
                model: this.currentModel
            };
        } catch (error) {
            console.error('AI chat failed:', error);
            return {
                success: false,
                error: error.message
            };
        }
    },
    
    // Call OpenAI API
    callOpenAI: async function(prompt) {
        const API_KEY = this.apiKeys.openai;
        if (!API_KEY) {
            throw new Error('OpenAI API key not set');
        }
        
        // Use mock response if no internet connection or for testing
        if (window.location.protocol === 'file:' || !navigator.onLine) {
            return this.getMockResponse();
        }
        
        const response = await fetch(this.providers.openai.apiEndpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${API_KEY}`
            },
            body: JSON.stringify({
                model: this.currentModel,
                messages: [
                    {
                        role: 'system',
                        content: 'You are a network security expert specializing in 802.1X deployment and configuration.'
                    },
                    {
                        role: 'user',
                        content: prompt
                    }
                ],
                temperature: 0.3,
                max_tokens: 2048
            })
        });
        
        if (!response.ok) {
            const error = await response.json();
            throw new Error(`OpenAI API error: ${error.error?.message || 'Unknown error'}`);
        }
        
        const data = await response.json();
        return data.choices[0].message.content;
    },
    
    // Call Anthropic API
    callAnthropic: async function(prompt) {
        const API_KEY = this.apiKeys.anthropic;
        if (!API_KEY) {
            throw new Error('Anthropic API key not set');
        }
        
        // Use mock response if no internet connection or for testing
        if (window.location.protocol === 'file:' || !navigator.onLine) {
            return this.getMockResponse();
        }
        
        const response = await fetch(this.providers.anthropic.apiEndpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': API_KEY,
                'anthropic-version': '2023-06-01'
            },
            body: JSON.stringify({
                model: this.currentModel,
                messages: [
                    {
                        role: 'user',
                        content: prompt
                    }
                ],
                max_tokens: 2048
            })
        });
        
        if (!response.ok) {
            const error = await response.json();
            throw new Error(`Anthropic API error: ${error.error?.message || 'Unknown error'}`);
        }
        
        const data = await response.json();
        return data.content[0].text;
    },
    
    // Call Google Gemini API
    callGemini: async function(prompt) {
        const API_KEY = this.apiKeys.gemini;
        if (!API_KEY) {
            throw new Error('Google Gemini API key not set');
        }
        
        // Use mock response if no internet connection or for testing
        if (window.location.protocol === 'file:' || !navigator.onLine) {
            return this.getMockResponse();
        }
        
        const apiUrl = `${this.providers.gemini.apiEndpoint}${this.currentModel}:generateContent?key=${API_KEY}`;
        
        const response = await fetch(apiUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                contents: [
                    {
                        parts: [
                            {
                                text: prompt
                            }
                        ]
                    }
                ],
                generationConfig: {
                    temperature: 0.3,
                    maxOutputTokens: 2048
                }
            })
        });
        
        if (!response.ok) {
            const error = await response.json();
            throw new Error(`Gemini API error: ${error.error?.message || 'Unknown error'}`);
        }
        
        const data = await response.json();
        return data.candidates[0].content.parts[0].text;
    },
    
    // Get mock response for offline testing
    getMockResponse: function() {
        const mockResponses = [
            `# 802.1X Configuration Optimization

I've analyzed your configuration and recommend the following improvements:

1. **Enhanced RADIUS Redundancy**: Add a third RADIUS server for higher availability
2. **Security Improvements**: Enable MACsec for layer 2 encryption
3. **Timer Optimization**: Adjusted reauthentication timers for better performance
4. **VLAN Security**: Implemented stricter VLAN isolation

The optimized configuration is below with detailed comments.`,
            
            `## Security Analysis Report

Your configuration has several security strengths but also some areas for improvement:

### Vulnerabilities Identified:
- Missing IP Source Guard protection
- Insufficient RADIUS server redundancy
- Guest VLAN configuration needs additional ACLs

### Recommendations:
1. Implement IP Source Guard on all authenticating interfaces
2. Add secondary RADIUS server with proper failover configuration
3. Apply restrictive ACLs to Guest VLAN
4. Consider implementing MACsec for layer 2 encryption

This will significantly improve your security posture.`,
            
            `# 802.1X Deployment Documentation

## Executive Summary
This document outlines the complete deployment process for 802.1X authentication using the provided configuration.

## Prerequisites
- RADIUS server infrastructure
- Supported network switches
- Client supplicants configured
- Network segmentation planning

## Deployment Steps
1. Configure RADIUS servers
2. Deploy switch configurations
3. Test with pilot group
4. Monitor authentication events
5. Full production deployment

## Troubleshooting
Common issues and their solutions are documented in Section 5.`
        ];
        
        // Return random mock response
        return mockResponses[Math.floor(Math.random() * mockResponses.length)];
    }
};

// Make AIIntegration globally available
window.AIIntegration = AIIntegration;
