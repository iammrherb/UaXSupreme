/**
 * Dot1Xer Supreme Enterprise Edition - Project Questionnaire
 * Version 4.1.0
 * 
 * This module handles the project questionnaire for gathering 802.1X 
 * deployment requirements and pre-populating configuration settings.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Project Questionnaire...');
    
    // Set up event handlers
    setupQuestionnaireEvents();
});

// Global variables
let currentQuestionIndex = 0;
const answers = {};
const questionnaireQuestions = [
    // Section 1: Project Information
    {
        title: "Project Information",
        questions: [
            {
                id: "project-name",
                text: "What is the name of your 802.1X deployment project?",
                type: "text",
                required: true,
                placeholder: "e.g., Corporate Network Security Enhancement"
            },
            {
                id: "organization-name",
                text: "What is your organization name?",
                type: "text",
                required: true,
                placeholder: "e.g., Acme Corporation"
            },
            {
                id: "project-deadline",
                text: "What is your target completion date for this project?",
                type: "date",
                required: false
            }
        ]
    },
    
    // Section 2: Network Information
    {
        title: "Network Information",
        questions: [
            {
                id: "network-size",
                text: "What is the approximate size of your network?",
                type: "radio",
                required: true,
                options: [
                    { value: "small", label: "Small (< 100 devices)" },
                    { value: "medium", label: "Medium (100-500 devices)" },
                    { value: "large", label: "Large (501-2000 devices)" },
                    { value: "enterprise", label: "Enterprise (> 2000 devices)" }
                ]
            },
            {
                id: "primary-vendor",
                text: "What is your primary network equipment vendor?",
                type: "select",
                required: true,
                options: [
                    { value: "", label: "-- Select Vendor --" },
                    { value: "cisco", label: "Cisco" },
                    { value: "aruba", label: "Aruba" },
                    { value: "juniper", label: "Juniper" },
                    { value: "hp", label: "HP" },
                    { value: "extreme", label: "Extreme" },
                    { value: "fortinet", label: "Fortinet" },
                    { value: "dell", label: "Dell" },
                    { value: "huawei", label: "Huawei" },
                    { value: "ruckus", label: "Ruckus" },
                    { value: "mixed", label: "Mixed Vendor Environment" }
                ]
            },
            {
                id: "mixed-vendors",
                text: "Which vendors are present in your environment?",
                type: "checkbox",
                required: false,
                condition: { id: "primary-vendor", value: "mixed" },
                options: [
                    { value: "cisco", label: "Cisco" },
                    { value: "aruba", label: "Aruba" },
                    { value: "juniper", label: "Juniper" },
                    { value: "hp", label: "HP" },
                    { value: "extreme", label: "Extreme" },
                    { value: "fortinet", label: "Fortinet" },
                    { value: "dell", label: "Dell" },
                    { value: "huawei", label: "Huawei" },
                    { value: "ruckus", label: "Ruckus" },
                    { value: "other", label: "Other" }
                ]
            },
            {
                id: "vlan-structure",
                text: "Do you have an existing VLAN structure in place?",
                type: "radio",
                required: true,
                options: [
                    { value: "yes", label: "Yes" },
                    { value: "no", label: "No" },
                    { value: "partial", label: "Partially" }
                ]
            }
        ]
    },
    
    // Section 3: Authentication Requirements
    {
        title: "Authentication Requirements",
        questions: [
            {
                id: "auth-server",
                text: "Which RADIUS server will you be using?",
                type: "select",
                required: true,
                options: [
                    { value: "", label: "-- Select RADIUS Server --" },
                    { value: "cisco-ise", label: "Cisco ISE" },
                    { value: "aruba-clearpass", label: "Aruba ClearPass" },
                    { value: "microsoft-nps", label: "Microsoft NPS" },
                    { value: "freeradius", label: "FreeRADIUS" },
                    { value: "packetfence", label: "PacketFence" },
                    { value: "other", label: "Other" }
                ]
            },
            {
                id: "auth-server-other",
                text: "Please specify your RADIUS server:",
                type: "text",
                required: false,
                condition: { id: "auth-server", value: "other" },
                placeholder: "e.g., Radiator, XSupplicant, etc."
            },
            {
                id: "auth-types",
                text: "Which authentication methods do you plan to implement?",
                type: "checkbox",
                required: true,
                options: [
                    { value: "dot1x", label: "802.1X" },
                    { value: "mab", label: "MAC Authentication Bypass (MAB)" },
                    { value: "webauth", label: "Web Authentication" }
                ]
            },
            {
                id: "eap-methods",
                text: "Which EAP methods do you plan to use?",
                type: "checkbox",
                required: false,
                condition: { id: "auth-types", value: "dot1x" },
                options: [
                    { value: "peap", label: "PEAP" },
                    { value: "eap-tls", label: "EAP-TLS" },
                    { value: "eap-ttls", label: "EAP-TTLS" },
                    { value: "eap-fast", label: "EAP-FAST" },
                    { value: "eap-md5", label: "EAP-MD5" }
                ]
            },
            {
                id: "identity-source",
                text: "What is your primary identity source?",
                type: "select",
                required: true,
                options: [
                    { value: "", label: "-- Select Identity Source --" },
                    { value: "active-directory", label: "Active Directory" },
                    { value: "ldap", label: "LDAP" },
                    { value: "local-db", label: "Local Database" },
                    { value: "certificates", label: "Certificate Authority" },
                    { value: "other", label: "Other" }
                ]
            }
        ]
    },
    
    // Section 4: Device Types
    {
        title: "Device Types",
        questions: [
            {
                id: "device-types",
                text: "What types of devices will connect to your network?",
                type: "checkbox",
                required: true,
                options: [
                    { value: "workstations", label: "Workstations/Laptops" },
                    { value: "phones", label: "IP Phones" },
                    { value: "printers", label: "Printers/Scanners" },
                    { value: "cameras", label: "IP Cameras" },
                    { value: "iot", label: "IoT Devices" },
                    { value: "byod", label: "BYOD Devices" },
                    { value: "guests", label: "Guest Devices" }
                ]
            },
            {
                id: "legacy-devices",
                text: "Do you have devices that cannot support 802.1X authentication?",
                type: "radio",
                required: true,
                options: [
                    { value: "yes", label: "Yes" },
                    { value: "no", label: "No" },
                    { value: "unknown", label: "Unknown" }
                ]
            },
            {
                id: "legacy-handling",
                text: "How would you like to handle devices that cannot support 802.1X?",
                type: "radio",
                required: false,
                condition: { id: "legacy-devices", value: "yes" },
                options: [
                    { value: "mab", label: "MAC Authentication Bypass (MAB)" },
                    { value: "dedicated-ports", label: "Dedicated Non-802.1X Ports" },
                    { value: "vlans", label: "Separate VLANs" },
                    { value: "not-decided", label: "Not Decided Yet" }
                ]
            },
            {
                id: "ip-phones",
                text: "Do you use IP phones in your environment?",
                type: "radio",
                required: true,
                options: [
                    { value: "yes", label: "Yes" },
                    { value: "no", label: "No" }
                ]
            },
            {
                id: "phone-vendor",
                text: "What is your IP phone vendor?",
                type: "select",
                required: false,
                condition: { id: "ip-phones", value: "yes" },
                options: [
                    { value: "", label: "-- Select Phone Vendor --" },
                    { value: "cisco", label: "Cisco" },
                    { value: "avaya", label: "Avaya" },
                    { value: "polycom", label: "Polycom" },
                    { value: "mitel", label: "Mitel" },
                    { value: "other", label: "Other" }
                ]
            }
        ]
    },
    
    // Section 5: Security Requirements
    {
        title: "Security Requirements",
        questions: [
            {
                id: "security-level",
                text: "What level of security are you aiming to achieve?",
                type: "radio",
                required: true,
                options: [
                    { value: "basic", label: "Basic (Authentication only)" },
                    { value: "medium", label: "Medium (Authentication with VLAN assignment)" },
                    { value: "high", label: "High (Authentication, VLAN assignment, and ACLs)" },
                    { value: "highest", label: "Highest (All above plus encryption)" }
                ]
            },
            {
                id: "use-macsec",
                text: "Do you plan to implement MACsec (802.1AE) encryption?",
                type: "radio",
                required: true,
                options: [
                    { value: "yes", label: "Yes" },
                    { value: "no", label: "No" },
                    { value: "future", label: "In a future phase" }
                ]
            },
            {
                id: "compliance-reqs",
                text: "Are there specific compliance requirements?",
                type: "checkbox",
                required: false,
                options: [
                    { value: "pci", label: "PCI DSS" },
                    { value: "hipaa", label: "HIPAA" },
                    { value: "fisma", label: "FISMA" },
                    { value: "gdpr", label: "GDPR" },
                    { value: "iso27001", label: "ISO 27001" },
                    { value: "other", label: "Other" },
                    { value: "none", label: "None" }
                ]
            },
            {
                id: "additional-security",
                text: "Which additional security features do you want to implement?",
                type: "checkbox",
                required: false,
                options: [
                    { value: "dhcp-snooping", label: "DHCP Snooping" },
                    { value: "dai", label: "Dynamic ARP Inspection" },
                    { value: "ipsg", label: "IP Source Guard" },
                    { value: "port-security", label: "Port Security" },
                    { value: "storm-control", label: "Storm Control" },
                    { value: "radius-coa", label: "RADIUS Change of Authorization (CoA)" }
                ]
            }
        ]
    },
    
    // Section 6: Deployment Strategy
    {
        title: "Deployment Strategy",
        questions: [
            {
                id: "deployment-approach",
                text: "What deployment approach do you prefer?",
                type: "radio",
                required: true,
                options: [
                    { value: "phased", label: "Phased (Monitor → Low Impact → Closed)" },
                    { value: "pilot", label: "Pilot Group First, Then Full Deployment" },
                    { value: "department", label: "Department by Department" },
                    { value: "location", label: "Location by Location" },
                    { value: "cutover", label: "Single Cutover (Not Recommended)" }
                ]
            },
            {
                id: "monitor-mode-duration",
                text: "How long do you plan to run in monitor mode?",
                type: "select",
                required: false,
                condition: { id: "deployment-approach", value: "phased" },
                options: [
                    { value: "1-week", label: "1 Week" },
                    { value: "2-weeks", label: "2 Weeks" },
                    { value: "1-month", label: "1 Month" },
                    { value: "2-months", label: "2 Months" },
                    { value: "custom", label: "Custom Duration" }
                ]
            },
            {
                id: "guest-access",
                text: "Do you need to provide network access for guests?",
                type: "radio",
                required: true,
                options: [
                    { value: "yes", label: "Yes" },
                    { value: "no", label: "No" }
                ]
            },
            {
                id: "guest-method",
                text: "How would you like to handle guest access?",
                type: "radio",
                required: false,
                condition: { id: "guest-access", value: "yes" },
                options: [
                    { value: "guest-vlan", label: "Guest VLAN for unauthenticated users" },
                    { value: "sponsor", label: "Sponsored guest accounts" },
                    { value: "self-reg", label: "Self-registration portal" },
                    { value: "separate", label: "Separate guest network" }
                ]
            }
        ]
    },
    
    // Section 7: Additional Information
    {
        title: "Additional Information",
        questions: [
            {
                id: "special-requirements",
                text: "Are there any special requirements or considerations for your deployment?",
                type: "textarea",
                required: false,
                placeholder: "Please describe any specific requirements or concerns..."
            },
            {
                id: "vlan-details",
                text: "Please provide details about your VLANs (Authentication, Guest, Voice, etc.)",
                type: "textarea",
                required: false,
                placeholder: "e.g., Auth VLAN 100, Guest VLAN 900, Voice VLAN 200..."
            },
            {
                id: "contact-person",
                text: "Who is the primary contact person for this project?",
                type: "text",
                required: false,
                placeholder: "Name, Email, Phone"
            }
        ]
    }
];

// Set up questionnaire event handlers
function setupQuestionnaireEvents() {
    // Questionnaire link click
    const questionnaireLink = document.getElementById('questionnaire-link');
    if (questionnaireLink) {
        questionnaireLink.addEventListener('click', function(e) {
            e.preventDefault();
            showQuestionnaire();
        });
    }
    
    // Modal close button
    const modalClose = document.getElementById('questionnaire-modal-close');
    if (modalClose) {
        modalClose.addEventListener('click', function() {
            hideQuestionnaire();
        });
    }
    
    // Next button
    const nextButton = document.getElementById('questionnaire-next');
    if (nextButton) {
        nextButton.addEventListener('click', function() {
            goToNextQuestion();
        });
    }
    
    // Previous button
    const prevButton = document.getElementById('questionnaire-previous');
    if (prevButton) {
        prevButton.addEventListener('click', function() {
            goToPreviousQuestion();
        });
    }
    
    // Finish button
    const finishButton = document.getElementById('questionnaire-finish');
    if (finishButton) {
        finishButton.addEventListener('click', function() {
            completeQuestionnaire();
        });
    }
}

// Show questionnaire modal
function showQuestionnaire() {
    const modal = document.getElementById('questionnaire-modal');
    if (modal) {
        // Reset questionnaire state
        currentQuestionIndex = 0;
        
        // Show first section
        showCurrentSection();
        
        // Show modal
        modal.classList.add('visible');
    }
}

// Hide questionnaire modal
function hideQuestionnaire() {
    const modal = document.getElementById('questionnaire-modal');
    if (modal) {
        modal.classList.remove('visible');
    }
}

// Show current question section
function showCurrentSection() {
    const container = document.getElementById('questionnaire-container');
    if (!container) return;
    
    const currentSection = questionnaireQuestions[currentQuestionIndex];
    if (!currentSection) return;
    
    // Create section content
    let content = `
        <div class="questionnaire-section">
            <h2>${currentSection.title}</h2>
            <p class="section-info">Section ${currentQuestionIndex + 1} of ${questionnaireQuestions.length}</p>
            <form id="questionnaire-form">
    `;
    
    // Add each question
    currentSection.questions.forEach((question) => {
        // Check if question should be shown based on conditions
        let showQuestion = true;
        if (question.condition) {
            const conditionValue = answers[question.condition.id];
            
            if (Array.isArray(conditionValue)) {
                // For checkbox conditions (arrays)
                showQuestion = conditionValue && conditionValue.includes(question.condition.value);
            } else {
                // For radio/select conditions (single values)
                showQuestion = conditionValue === question.condition.value;
            }
        }
        
        if (!showQuestion) return;
        
        content += `
            <div class="form-group">
                <label for="${question.id}">${question.text}${question.required ? ' <span class="required">*</span>' : ''}</label>
        `;
        
        // Handle different question types
        switch (question.type) {
            case 'text':
                content += `
                    <input type="text" id="${question.id}" name="${question.id}" class="form-control" 
                    ${question.placeholder ? `placeholder="${question.placeholder}"` : ''} 
                    ${question.required ? 'required' : ''} 
                    ${answers[question.id] ? `value="${answers[question.id]}"` : ''}>
                `;
                break;
                
            case 'textarea':
                content += `
                    <textarea id="${question.id}" name="${question.id}" class="form-control" 
                    ${question.placeholder ? `placeholder="${question.placeholder}"` : ''} 
                    ${question.required ? 'required' : ''}>${answers[question.id] || ''}</textarea>
                `;
                break;
                
            case 'date':
                content += `
                    <input type="date" id="${question.id}" name="${question.id}" class="form-control" 
                    ${question.required ? 'required' : ''} 
                    ${answers[question.id] ? `value="${answers[question.id]}"` : ''}>
                `;
                break;
                
            case 'select':
                content += `<select id="${question.id}" name="${question.id}" class="form-control" ${question.required ? 'required' : ''}>`;
                
                question.options.forEach(option => {
                    const selected = answers[question.id] === option.value ? 'selected' : '';
                    content += `<option value="${option.value}" ${selected}>${option.label}</option>`;
                });
                
                content += `</select>`;
                break;
                
            case 'radio':
                content += `<div class="radio-group">`;
                
                question.options.forEach(option => {
                    const checked = answers[question.id] === option.value ? 'checked' : '';
                    content += `
                        <div class="radio">
                            <input type="radio" id="${question.id}-${option.value}" name="${question.id}" 
                            value="${option.value}" ${checked} ${question.required ? 'required' : ''}>
                            <label for="${question.id}-${option.value}">${option.label}</label>
                        </div>
                    `;
                });
                
                content += `</div>`;
                break;
                
            case 'checkbox':
                content += `<div class="checkbox-group">`;
                
                question.options.forEach(option => {
                    const checked = answers[question.id] && Array.isArray(answers[question.id]) && 
                                   answers[question.id].includes(option.value) ? 'checked' : '';
                    
                    content += `
                        <div class="checkbox">
                            <input type="checkbox" id="${question.id}-${option.value}" name="${question.id}" 
                            value="${option.value}" ${checked}>
                            <label for="${question.id}-${option.value}">${option.label}</label>
                        </div>
                    `;
                });
                
                content += `</div>`;
                break;
        }
        
        content += `</div>`;
    });
    
    content += `</form></div>`;
    
    // Update container
    container.innerHTML = content;
    
    // Update button states
    updateNavigationButtons();
    
    // Add event listeners for condition-based questions
    addConditionalQuestionListeners();
}

// Add listeners for questions that have conditions
function addConditionalQuestionListeners() {
    const currentSection = questionnaireQuestions[currentQuestionIndex];
    if (!currentSection) return;
    
    currentSection.questions.forEach(question => {
        // Find questions that have conditions
        const dependentQuestions = currentSection.questions.filter(q => 
            q.condition && q.condition.id === question.id
        );
        
        if (dependentQuestions.length === 0) return;
        
        // Add appropriate event listeners based on question type
        switch (question.type) {
            case 'radio':
                const radioInputs = document.querySelectorAll(`input[name="${question.id}"]`);
                radioInputs.forEach(input => {
                    input.addEventListener('change', () => {
                        // Save the answer
                        saveCurrentAnswers();
                        // Re-render the section to show/hide dependent questions
                        showCurrentSection();
                    });
                });
                break;
                
            case 'select':
                const selectInput = document.getElementById(question.id);
                if (selectInput) {
                    selectInput.addEventListener('change', () => {
                        // Save the answer
                        saveCurrentAnswers();
                        // Re-render the section to show/hide dependent questions
                        showCurrentSection();
                    });
                }
                break;
                
            case 'checkbox':
                const checkboxInputs = document.querySelectorAll(`input[name="${question.id}"]`);
                checkboxInputs.forEach(input => {
                    input.addEventListener('change', () => {
                        // Save the answer
                        saveCurrentAnswers();
                        // Re-render the section to show/hide dependent questions
                        showCurrentSection();
                    });
                });
                break;
        }
    });
}

// Update navigation buttons
function updateNavigationButtons() {
    const prevButton = document.getElementById('questionnaire-previous');
    const nextButton = document.getElementById('questionnaire-next');
    const finishButton = document.getElementById('questionnaire-finish');
    
    if (prevButton) {
        prevButton.style.display = currentQuestionIndex > 0 ? 'block' : 'none';
    }
    
    if (nextButton && finishButton) {
        if (currentQuestionIndex < questionnaireQuestions.length - 1) {
            nextButton.style.display = 'block';
            finishButton.style.display = 'none';
        } else {
            nextButton.style.display = 'none';
            finishButton.style.display = 'block';
        }
    }
}

// Go to the next question
function goToNextQuestion() {
    // Save current answers
    if (!saveCurrentAnswers()) {
        // Don't proceed if validation fails
        return;
    }
    
    // Move to next section
    if (currentQuestionIndex < questionnaireQuestions.length - 1) {
        currentQuestionIndex++;
        showCurrentSection();
    }
}

// Go to the previous question
function goToPreviousQuestion() {
    // Save current answers (but don't validate)
    saveCurrentAnswers(false);
    
    // Move to previous section
    if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        showCurrentSection();
    }
}

// Save current answers
function saveCurrentAnswers(validate = true) {
    const form = document.getElementById('questionnaire-form');
    if (!form) return true;
    
    // Check form validity if validation is enabled
    if (validate && !form.checkValidity()) {
        // Show validation messages
        form.reportValidity();
        return false;
    }
    
    // Get all form elements
    const elements = form.elements;
    const currentSection = questionnaireQuestions[currentQuestionIndex];
    
    if (!currentSection) return true;
    
    // Process each question in the current section
    currentSection.questions.forEach(question => {
        switch (question.type) {
            case 'text':
            case 'textarea':
            case 'date':
            case 'select':
                const element = document.getElementById(question.id);
                if (element) {
                    answers[question.id] = element.value;
                }
                break;
                
            case 'radio':
                const selectedRadio = document.querySelector(`input[name="${question.id}"]:checked`);
                if (selectedRadio) {
                    answers[question.id] = selectedRadio.value;
                }
                break;
                
            case 'checkbox':
                const checkedBoxes = document.querySelectorAll(`input[name="${question.id}"]:checked`);
                if (checkedBoxes.length > 0) {
                    answers[question.id] = Array.from(checkedBoxes).map(cb => cb.value);
                } else {
                    answers[question.id] = [];
                }
                break;
        }
    });
    
    return true;
}

// Complete the questionnaire
function completeQuestionnaire() {
    // Save final answers
    if (!saveCurrentAnswers()) {
        return;
    }
    
    // Process answers to pre-populate configuration
    applyAnswersToConfiguration();
    
    // Hide questionnaire
    hideQuestionnaire();
    
    // Show confirmation message
    showAlert('Questionnaire completed successfully. Settings have been applied.', 'success');
}

// Apply questionnaire answers to configuration settings
function applyAnswersToConfiguration() {
    // Map answers to configuration fields
    
    // 1. Vendor & Platform
    if (answers['primary-vendor'] && answers['primary-vendor'] !== 'mixed') {
        selectVendor(answers['primary-vendor']);
    }
    
    // 2. Authentication settings
    if (answers['auth-types']) {
        // Set authentication method based on selected types
        const authTypes = answers['auth-types'];
        let authMethod = 'dot1x'; // Default
        
        if (authTypes.includes('dot1x') && authTypes.includes('mab') && authTypes.includes('webauth')) {
            authMethod = 'dot1x-mab-webauth';
        } else if (authTypes.includes('dot1x') && authTypes.includes('mab')) {
            authMethod = 'dot1x-mab';
        } else if (authTypes.includes('mab') && !authTypes.includes('dot1x')) {
            authMethod = 'mab';
        }
        
        setSelectValue('auth-method', authMethod);
    }
    
    // Set auth mode based on deployment approach
    if (answers['deployment-approach'] === 'phased') {
        setRadioValue('auth-mode', 'open'); // Start with monitor mode
    } else {
        setRadioValue('auth-mode', 'closed');
    }
    
    // 3. Host mode based on device types
    if (answers['device-types'] && answers['ip-phones']) {
        if (answers['device-types'].includes('phones') && answers['ip-phones'] === 'yes') {
            setSelectValue('host-mode', 'multi-domain');
        } else if (answers['device-types'].length > 2) {
            // Multiple device types suggest multi-auth
            setSelectValue('host-mode', 'multi-auth');
        }
    }
    
    // 4. RADIUS server settings
    if (answers['auth-server']) {
        // We don't have the actual IP, but we can set a placeholder
        setInputValue('radius-server-1', '10.0.0.1');
        
        // Set secondary server placeholder if high security is selected
        if (answers['security-level'] === 'high' || answers['security-level'] === 'highest') {
            setInputValue('radius-server-2', '10.0.0.2');
        }
    }
    
    // 5. VLAN settings from textarea
    if (answers['vlan-details']) {
        // Try to extract VLAN information from the provided text
        extractAndSetVlans(answers['vlan-details']);
    }
    
    // 6. Security features
    if (answers['security-level'] === 'highest' || (answers['use-macsec'] && answers['use-macsec'] === 'yes')) {
        setCheckboxValue('use-macsec', true);
    }
    
    if (answers['additional-security']) {
        if (answers['additional-security'].includes('dhcp-snooping')) {
            setCheckboxValue('enable-dhcp-snooping', true);
        }
        
        if (answers['additional-security'].includes('dai')) {
            setCheckboxValue('enable-dai', true);
        }
        
        if (answers['additional-security'].includes('ipsg')) {
            setCheckboxValue('enable-ipsg', true);
        }
        
        if (answers['additional-security'].includes('radius-coa')) {
            setCheckboxValue('use-coa', true);
        } else {
            setCheckboxValue('use-coa', false);
        }
    }
    
    // 7. Deployment strategy
    if (answers['deployment-approach']) {
        let strategy = 'monitor';
        
        if (answers['deployment-approach'] === 'phased') {
            strategy = 'monitor';
        } else if (answers['deployment-approach'] === 'pilot' || answers['deployment-approach'] === 'department') {
            strategy = 'low-impact';
        } else if (answers['deployment-approach'] === 'cutover') {
            strategy = 'closed';
        }
        
        setRadioValue('deploy-strategy', strategy);
    }
    
    // 8. Industry type
    if (answers['compliance-reqs']) {
        if (answers['compliance-reqs'].includes('hipaa')) {
            setSelectValue('industry-type', 'healthcare');
        } else if (answers['compliance-reqs'].includes('pci')) {
            setSelectValue('industry-type', 'retail');
        } else if (answers['compliance-reqs'].includes('fisma')) {
            setSelectValue('industry-type', 'government');
        } else if (answers['compliance-reqs'].includes('gdpr') || answers['compliance-reqs'].includes('iso27001')) {
            setSelectValue('industry-type', 'enterprise');
        }
    }
}

// Select a vendor in the UI
function selectVendor(vendorId) {
    const vendorContainers = document.querySelectorAll('.vendor-logo-container');
    vendorContainers.forEach(container => {
        if (container.getAttribute('data-vendor') === vendorId) {
            // Remove selected class from all vendors
            vendorContainers.forEach(v => v.classList.remove('selected'));
            
            // Add selected class to clicked vendor
            container.classList.add('selected');
            
            // Trigger change event
            const event = new CustomEvent('vendorChange', { detail: { vendor: vendorId } });
            document.dispatchEvent(event);
        }
    });
}

// Set value for a select element
function setSelectValue(id, value) {
    const element = document.getElementById(id);
    if (element && element.tagName === 'SELECT') {
        element.value = value;
        
        // Trigger change event
        const event = new Event('change');
        element.dispatchEvent(event);
    }
}

// Set value for an input element
function setInputValue(id, value) {
    const element = document.getElementById(id);
    if (element && (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA')) {
        element.value = value;
    }
}

// Set value for a radio button
function setRadioValue(name, value) {
    const radio = document.querySelector(`input[name="${name}"][value="${value}"]`);
    if (radio) {
        radio.checked = true;
        
        // Trigger change event
        const event = new Event('change');
        radio.dispatchEvent(event);
    }
}

// Set value for a checkbox
function setCheckboxValue(id, checked) {
    const checkbox = document.getElementById(id);
    if (checkbox && checkbox.type === 'checkbox') {
        checkbox.checked = checked;
        
        // Trigger change event
        const event = new Event('change');
        checkbox.dispatchEvent(event);
    }
}

// Extract and set VLAN information from text
function extractAndSetVlans(text) {
    // Common VLAN naming patterns
    const patterns = {
        auth: /auth(entication)?[\s-]*vlan[\s:]*(\d+)/i,
        unauth: /unauth(enticated|orized)?[\s-]*vlan[\s:]*(\d+)/i,
        guest: /guest[\s-]*vlan[\s:]*(\d+)/i,
        voice: /voice[\s-]*vlan[\s:]*(\d+)/i,
        critical: /critical[\s-]*vlan[\s:]*(\d+)/i
    };
    
    // Try to match and set each VLAN
    for (const [type, pattern] of Object.entries(patterns)) {
        const match = text.match(pattern);
        if (match && match[2]) {
            setInputValue(`vlan-${type}`, match[2]);
        }
    }
}

// Helper function to show alerts
function showAlert(message, type = 'info') {
    // If the global alert function is available, use it
    if (typeof window.showAlert === 'function') {
        window.showAlert(message, type);
        return;
    }
    
    // Simple alert fallback
    alert(message);
}
