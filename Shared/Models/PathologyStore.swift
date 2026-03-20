import Foundation

struct PathologyStore {
    static let all: [Pathology] = [

        // MARK: - Neurodegenerative

        Pathology(
            id: "alzheimers-disease",
            name: "Alzheimer's Disease",
            category: .neurodegenerative,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Progressive episodic memory loss (recent events first)",
                    "Word-finding difficulty (anomia)",
                    "Visuospatial disorientation and getting lost",
                    "Impaired judgment and executive dysfunction",
                    "Apraxia in later stages",
                    "Behavioral changes: apathy, agitation, wandering"
                ],
                observableBehaviors: [
                    "Repeats questions and stories within minutes",
                    "Misplaces items in unusual locations",
                    "Difficulty managing finances and medications",
                    "Gets lost in familiar environments",
                    "Withdrawal from social activities",
                    "Sundowning (increased confusion in evening)"
                ],
                onset: "Insidious onset, typically after age 65 (late-onset) or 40-65 (early-onset/familial)",
                progression: "Gradual progressive decline over 8-12 years from diagnosis to death. Stages: preclinical, MCI due to AD, mild, moderate, severe dementia."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Episodic Memory", severity: .severe, description: "Encoding deficit: poor free recall with minimal benefit from cues or recognition formats. Rapid forgetting on delayed recall."),
                    CognitiveDomain(domain: "Semantic Memory", severity: .moderate, description: "Category fluency impaired more than letter fluency. Loss of semantic knowledge in moderate stages."),
                    CognitiveDomain(domain: "Executive Function", severity: .moderate, description: "Impaired set-shifting (TMT-B), planning, and abstract reasoning. Relatively preserved in earliest stages."),
                    CognitiveDomain(domain: "Visuospatial", severity: .moderate, description: "Clock drawing errors, copy deficits, impaired spatial navigation. May present as posterior cortical atrophy variant."),
                    CognitiveDomain(domain: "Language", severity: .mild, description: "Anomia progressing to fluent aphasia. Reduced verbal fluency. Comprehension and repetition preserved early.")
                ],
                expectedTestPatterns: [
                    "CVLT/RAVLT: Flat learning curve, rapid forgetting, many intrusion errors, poor recognition discriminability",
                    "Clock Drawing: Spatial errors, misplacement of numbers, conceptual errors",
                    "Boston Naming Test: Impaired with semantic paraphasias",
                    "TMT-B: Disproportionately impaired relative to TMT-A",
                    "Category fluency (animals) < Letter fluency (FAS) deficit ratio",
                    "Rey Complex Figure: Poor copy and severely impaired delayed recall"
                ],
                preservedFunctions: [
                    "Procedural/motor memory (early stages)",
                    "Remote autobiographical memory (early stages)",
                    "Basic attention and processing speed (early stages)",
                    "Social comportment (early stages)",
                    "Musical memory"
                ],
                differentialConsiderations: [
                    "Vascular dementia: stepwise decline, focal neurological signs",
                    "Lewy body dementia: visual hallucinations, fluctuating cognition, parkinsonism",
                    "Frontotemporal dementia: personality changes precede memory loss",
                    "Depression-related cognitive impairment: effortful processing deficit, benefits from cues"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Bilateral hippocampal and medial temporal lobe atrophy (earliest structural finding)",
                    "Temporoparietal cortical atrophy",
                    "Enlarged lateral ventricles (ex vacuo hydrocephalus)",
                    "Posterior cingulate and precuneus atrophy",
                    "Relative frontal and occipital sparing (typical variant)"
                ],
                ct: [
                    "Generalized cerebral atrophy with prominent sulci",
                    "Medial temporal lobe atrophy visible in coronal cuts",
                    "Ventricular enlargement disproportionate to sulcal widening"
                ],
                pet: [
                    "FDG-PET: Temporoparietal and posterior cingulate hypometabolism",
                    "Amyloid PET (Pittsburgh Compound B): Diffuse cortical amyloid deposition",
                    "Tau PET: Medial temporal tau accumulation correlating with cognitive decline",
                    "Frontal metabolism relatively preserved early"
                ],
                otherModalities: [
                    ImagingFinding(modality: "CSF Biomarkers", findings: ["Low amyloid-beta 42", "Elevated phospho-tau and total tau", "A/T/N biomarker framework classification"])
                ]
            ),
            relatedStructures: ["hippocampus", "cingulate-cortex", "angular-gyrus", "prefrontal-cortex"],
            epidemiology: "Most common cause of dementia (60-80%). Prevalence doubles every 5 years after age 65. ~6 million in US.",
            etiology: "Amyloid-beta plaque accumulation and neurofibrillary tau tangles leading to neuronal death. Genetic risk: APOE4 allele (late-onset), APP/PSEN1/PSEN2 mutations (early-onset)."
        ),

        Pathology(
            id: "frontotemporal-dementia",
            name: "Frontotemporal Dementia",
            category: .neurodegenerative,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Behavioral variant: personality change, disinhibition, apathy",
                    "Semantic variant: progressive loss of word and object meaning",
                    "Nonfluent variant: effortful speech, agrammatism",
                    "Loss of empathy and social awareness",
                    "Compulsive or ritualistic behaviors",
                    "Dietary changes (sweet food craving, overeating)"
                ],
                observableBehaviors: [
                    "Socially inappropriate comments or actions",
                    "Loss of manners and personal hygiene",
                    "Hoarding or repetitive behaviors",
                    "Emotional blunting or inappropriate jocularity",
                    "Difficulty following conversations (semantic variant)",
                    "Telegraphic, halting speech (nonfluent variant)"
                ],
                onset: "Typically ages 45-65 (younger than AD). Most common dementia in under-60 population.",
                progression: "Progressive over 6-8 years. Behavioral variant may initially be misdiagnosed as psychiatric illness."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Executive Function", severity: .severe, description: "Poor set-shifting, perseveration, impaired planning, poor abstraction. Core deficit in behavioral variant."),
                    CognitiveDomain(domain: "Social Cognition", severity: .severe, description: "Theory of mind impairment, loss of empathy, poor emotion recognition especially negative emotions."),
                    CognitiveDomain(domain: "Language", severity: .variable, description: "Semantic variant: impaired naming, word comprehension, object knowledge. Nonfluent: effortful speech, agrammatism."),
                    CognitiveDomain(domain: "Memory", severity: .mild, description: "Relatively preserved episodic memory early. Benefit from cues/recognition unlike AD. Encoding is intact but retrieval is disorganized.")
                ],
                expectedTestPatterns: [
                    "WCST: Excessive perseverative errors",
                    "Letter fluency (FAS) more impaired than category fluency (opposite of AD pattern)",
                    "Stroop: Marked interference effect",
                    "Iowa Gambling Task: Impaired reward-based decision making",
                    "CVLT: Disorganized recall but benefits from cues (unlike AD)",
                    "Facial Emotion Recognition: Impaired for negative emotions"
                ],
                preservedFunctions: [
                    "Visuospatial abilities (early stages)",
                    "Episodic memory encoding (early stages)",
                    "Orientation to time and place (early stages)",
                    "Basic attention and processing speed"
                ],
                differentialConsiderations: [
                    "Alzheimer's disease: memory-first presentation, temporoparietal atrophy",
                    "Psychiatric disorders (bipolar, late-onset schizophrenia): episodic vs progressive",
                    "Primary progressive aphasia subtypes need careful language assessment",
                    "Corticobasal degeneration: motor features, asymmetric atrophy"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Frontal and/or anterior temporal lobe atrophy (often asymmetric)",
                    "Behavioral variant: bilateral frontal and anterior temporal atrophy",
                    "Semantic variant: left anterior temporal lobe atrophy (knife-blade pattern)",
                    "Nonfluent variant: left inferior frontal and insular atrophy"
                ],
                ct: [
                    "Frontal and temporal lobe atrophy with prominent frontal sulci",
                    "Relatively preserved posterior structures (unlike AD)"
                ],
                pet: [
                    "FDG-PET: Frontal and anterior temporal hypometabolism",
                    "Negative amyloid PET (differentiates from AD)",
                    "Selective frontal hypoperfusion on SPECT"
                ],
                otherModalities: []
            ),
            relatedStructures: ["prefrontal-cortex", "orbitofrontal-cortex", "inferior-temporal-cortex", "brocas-area"],
            epidemiology: "Second most common cause of presenile dementia. Prevalence ~15-22 per 100,000 in 45-64 age group.",
            etiology: "Tau or TDP-43 protein accumulation. ~40% familial with mutations in MAPT, GRN, or C9orf72 genes."
        ),

        Pathology(
            id: "parkinsons-disease",
            name: "Parkinson's Disease",
            category: .movement,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Resting tremor (pill-rolling, 4-6 Hz)",
                    "Bradykinesia (slowness of movement)",
                    "Cogwheel rigidity",
                    "Postural instability (late feature)",
                    "Masked facies (reduced facial expression)",
                    "Micrographia (progressively smaller handwriting)",
                    "Shuffling gait with reduced arm swing",
                    "Non-motor: anosmia, REM sleep behavior disorder, constipation, depression"
                ],
                observableBehaviors: [
                    "Slow to initiate movements, hesitant gait",
                    "Soft monotone voice (hypophonia)",
                    "Difficulty with fine motor tasks (buttoning, writing)",
                    "Freezing episodes during walking",
                    "Reduced blink rate and flat affect",
                    "Difficulty turning over in bed"
                ],
                onset: "Mean age 60. Prodromal phase with anosmia and RBD may precede motor symptoms by years.",
                progression: "Slowly progressive. Medication-responsive early. Motor fluctuations and dyskinesias develop after 5-10 years of L-DOPA therapy."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Executive Function", severity: .moderate, description: "Set-shifting, planning, and cognitive flexibility impaired. Frontostriatal circuit dysfunction."),
                    CognitiveDomain(domain: "Visuospatial", severity: .moderate, description: "Impaired spatial planning and mental rotation. Clock drawing and figure copy deficits."),
                    CognitiveDomain(domain: "Processing Speed", severity: .moderate, description: "Psychomotor slowing (bradyphrenia) parallels motor bradykinesia. Timed tasks disproportionately affected."),
                    CognitiveDomain(domain: "Memory", severity: .mild, description: "Retrieval deficit: poor free recall but intact recognition. Distinct from the encoding deficit of AD.")
                ],
                expectedTestPatterns: [
                    "TMT-B: Impaired (executive dysfunction)",
                    "WCST: Increased perseverative errors",
                    "CVLT: Poor free recall, normalized by recognition (retrieval deficit)",
                    "Judgment of Line Orientation: Impaired",
                    "Clock Drawing: Executive-type errors (planning, sequencing)",
                    "Letter fluency impaired; category fluency may be relatively preserved"
                ],
                preservedFunctions: [
                    "Language (naming, comprehension) in early stages",
                    "Recognition memory (vs free recall)",
                    "Semantic knowledge",
                    "Long-term procedural memory"
                ],
                differentialConsiderations: [
                    "Lewy body dementia: dementia before or within 1 year of motor symptoms",
                    "Progressive supranuclear palsy: vertical gaze palsy, axial rigidity, frequent falls",
                    "Multiple system atrophy: autonomic failure, cerebellar signs",
                    "Vascular parkinsonism: lower body predominance, stepwise course"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Structural MRI often normal in early disease",
                    "Subtle cortical thinning in frontal and parietal regions in PD with cognitive impairment",
                    "Loss of dorsolateral nigral hyperintensity on susceptibility-weighted imaging (SWI)"
                ],
                ct: [
                    "CT typically normal (used mainly to exclude other pathology)",
                    "May show mild generalized atrophy in advanced disease"
                ],
                pet: [
                    "DaT-SPECT: Reduced dopamine transporter uptake in putamen (comma to period sign)",
                    "FDG-PET: Parkinson disease-related metabolic pattern (PDRP) with increased pallidothalamic activity",
                    "Decreased fluorodopa uptake in posterior putamen"
                ],
                otherModalities: [
                    ImagingFinding(modality: "Transcranial Ultrasound", findings: ["Hyperechogenicity of substantia nigra"])
                ]
            ),
            relatedStructures: ["basal-ganglia-putamen", "globus-pallidus", "midbrain", "basal-ganglia-caudate"],
            epidemiology: "Second most common neurodegenerative disease. Prevalence ~1% over age 60, ~4% over age 80.",
            etiology: "Loss of dopaminergic neurons in substantia nigra pars compacta. Alpha-synuclein (Lewy body) accumulation. Genetic: LRRK2, GBA, SNCA, Parkin mutations."
        ),

        Pathology(
            id: "huntingtons-disease",
            name: "Huntington's Disease",
            category: .neurodegenerative,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Chorea (involuntary, irregular, flowing movements)",
                    "Progressive cognitive decline (subcortical dementia pattern)",
                    "Psychiatric symptoms: depression, irritability, apathy",
                    "Dystonia and rigidity (later stages)",
                    "Oculomotor abnormalities (impaired saccades)",
                    "Dysphagia and dysarthria",
                    "Weight loss"
                ],
                observableBehaviors: [
                    "Fidgety, restless movements incorporated into voluntary actions",
                    "Clumsiness and falls",
                    "Impulsive decision-making",
                    "Social withdrawal and irritability",
                    "Slurred, irregular speech",
                    "Difficulty with complex motor sequences"
                ],
                onset: "Typically ages 30-50. Juvenile onset (<20 years) with >60 CAG repeats is more severe (Westphal variant).",
                progression: "Relentlessly progressive over 15-20 years. Motor, cognitive, and psychiatric domains all worsen. Fatal."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Executive Function", severity: .severe, description: "Earliest and most prominent cognitive deficit. Impaired planning, set-shifting, cognitive flexibility."),
                    CognitiveDomain(domain: "Processing Speed", severity: .severe, description: "Marked psychomotor slowing. Timed tests disproportionately impaired."),
                    CognitiveDomain(domain: "Memory", severity: .moderate, description: "Retrieval deficit pattern: poor free recall, improved with cues/recognition. Procedural memory impaired early."),
                    CognitiveDomain(domain: "Visuospatial", severity: .moderate, description: "Impaired spatial judgment and mental rotation."),
                    CognitiveDomain(domain: "Emotion Recognition", severity: .moderate, description: "Selective impairment recognizing disgust, then other negative emotions.")
                ],
                expectedTestPatterns: [
                    "Symbol Digit Modalities Test: Marked impairment (sensitive early marker)",
                    "Stroop Color-Word: Impaired interference control",
                    "CVLT: Poor free recall, improved with recognition cues",
                    "WCST: Perseverative errors and failure to maintain set",
                    "Verbal fluency: Letter and category both impaired",
                    "Timed motor tasks: Disproportionately slow"
                ],
                preservedFunctions: [
                    "Language comprehension (early stages)",
                    "Recognition memory (relative to free recall)",
                    "Orientation (early stages)",
                    "Reading ability"
                ],
                differentialConsiderations: [
                    "Wilson's disease: copper metabolism disorder, Kayser-Fleischer rings",
                    "Chorea-acanthocytosis: acanthocytes on blood smear",
                    "Tardive dyskinesia: neuroleptic exposure history",
                    "Benign hereditary chorea: non-progressive, childhood onset"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Caudate nucleus atrophy with flattening of caudate head (box-car ventricles)",
                    "Putaminal atrophy",
                    "Frontal and temporal cortical atrophy in advanced disease",
                    "Ex vacuo enlargement of frontal horns of lateral ventricles"
                ],
                ct: [
                    "Caudate atrophy with enlarged frontal horns",
                    "Bicaudate ratio increased (>0.18 abnormal)"
                ],
                pet: [
                    "FDG-PET: Caudate and putaminal hypometabolism (earliest PET finding)",
                    "Reduced dopamine D2 receptor binding in striatum",
                    "Cortical hypometabolism in advanced stages"
                ],
                otherModalities: [
                    ImagingFinding(modality: "Genetic Testing", findings: ["CAG trinucleotide repeat expansion in HTT gene (>36 repeats pathological)"])
                ]
            ),
            relatedStructures: ["basal-ganglia-caudate", "basal-ganglia-putamen", "globus-pallidus", "prefrontal-cortex"],
            epidemiology: "Prevalence ~5-10 per 100,000 in Western populations. Autosomal dominant inheritance with full penetrance.",
            etiology: "CAG trinucleotide repeat expansion in huntingtin (HTT) gene on chromosome 4. Mutant huntingtin protein causes neuronal toxicity, primarily in striatum."
        ),

        // MARK: - Vascular

        Pathology(
            id: "stroke-mca",
            name: "Middle Cerebral Artery Stroke",
            category: .vascular,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Contralateral hemiparesis (face and arm > leg)",
                    "Contralateral hemisensory loss",
                    "Left MCA: Broca's and/or Wernicke's aphasia",
                    "Right MCA: Hemispatial neglect, anosognosia",
                    "Homonymous hemianopia",
                    "Gaze deviation toward lesion side (acute)"
                ],
                observableBehaviors: [
                    "Facial drooping on one side",
                    "Inability to lift arm or leg on affected side",
                    "Slurred or absent speech (left hemisphere)",
                    "Ignoring one side of space (right hemisphere)",
                    "Confusion and disorientation",
                    "Denial of deficits (anosognosia with right hemisphere)"
                ],
                onset: "Sudden onset (minutes to hours). Ischemic (85%) or hemorrhagic (15%).",
                progression: "Maximal deficit at onset, then gradual improvement over weeks to months. Residual deficits common."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Language", severity: .severe, description: "Left MCA: Broca's (non-fluent), Wernicke's (fluent), or global aphasia depending on extent. Anomia common."),
                    CognitiveDomain(domain: "Attention", severity: .severe, description: "Right MCA: Hemispatial neglect (left-sided), impaired sustained attention, anosognosia for deficits."),
                    CognitiveDomain(domain: "Motor/Praxis", severity: .moderate, description: "Apraxia (left hemisphere), impaired motor programming, constructional difficulties."),
                    CognitiveDomain(domain: "Visuospatial", severity: .moderate, description: "Right MCA: Visuoconstructional deficits, spatial disorientation, impaired facial recognition.")
                ],
                expectedTestPatterns: [
                    "Left MCA: Boston Naming Test impaired, impaired verbal fluency, preserved visuospatial",
                    "Right MCA: Line bisection shifted rightward, figure copy with left-sided omissions",
                    "Star/letter cancellation: Left-sided omissions (right MCA)",
                    "WAB or BDAE for aphasia classification and severity",
                    "Lateralized motor deficits on finger tapping and grip strength"
                ],
                preservedFunctions: [
                    "Contralateral hemisphere functions typically intact",
                    "Procedural memory usually preserved",
                    "Lower extremity function often relatively spared (ACA territory)",
                    "Subcortical functions if cortical stroke"
                ],
                differentialConsiderations: [
                    "TIA: Symptoms resolve within 24 hours",
                    "Hemorrhagic stroke: More severe headache, earlier decreased consciousness",
                    "Brain tumor: Gradual onset, may mimic stroke acutely",
                    "Todd's paralysis: Post-seizure transient deficit"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "DWI: Restricted diffusion in MCA territory within minutes of onset",
                    "FLAIR: Hyperintensity developing 6+ hours after onset",
                    "MRA: MCA occlusion or stenosis",
                    "Perfusion MRI: Mismatch between diffusion and perfusion (penumbra = salvageable tissue)"
                ],
                ct: [
                    "Non-contrast CT: Hyperdense MCA sign (acute clot), loss of gray-white differentiation",
                    "Hypoattenuation in MCA territory developing over 6-12 hours",
                    "CT angiography: Large vessel occlusion",
                    "CT perfusion: Core infarct vs penumbra assessment"
                ],
                pet: [
                    "FDG-PET: Hypometabolism in infarcted territory and diaschisis in connected regions",
                    "Crossed cerebellar diaschisis (reduced contralateral cerebellar metabolism)"
                ],
                otherModalities: [
                    ImagingFinding(modality: "Carotid Ultrasound", findings: ["Carotid stenosis or plaque as embolic source"])
                ]
            ),
            relatedStructures: ["primary-motor-cortex", "brocas-area", "wernickes-area", "primary-somatosensory-cortex", "parietal-inferior"],
            epidemiology: "MCA is the most commonly affected artery in stroke. Stroke is the 5th leading cause of death and leading cause of disability in the US.",
            etiology: "Ischemic: thrombotic or embolic occlusion. Risk factors: hypertension, atrial fibrillation, diabetes, smoking, hyperlipidemia."
        ),

        Pathology(
            id: "wallenberg-syndrome",
            name: "Wallenberg Syndrome (Lateral Medullary Syndrome)",
            category: .vascular,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Vertigo, nausea, nystagmus",
                    "Ipsilateral facial pain and temperature loss (CN V nucleus)",
                    "Contralateral body pain and temperature loss (spinothalamic tract)",
                    "Ipsilateral Horner syndrome (ptosis, miosis, anhidrosis)",
                    "Dysphagia and hoarseness (CN IX/X)",
                    "Ipsilateral cerebellar ataxia",
                    "Hiccups"
                ],
                observableBehaviors: [
                    "Difficulty swallowing, coughing on liquids",
                    "Hoarse voice and nasal speech",
                    "Veering gait to the ipsilateral side",
                    "Head tilted away from lesion",
                    "One pupil smaller than the other",
                    "Reports intense spinning sensation"
                ],
                onset: "Sudden onset. PICA or vertebral artery occlusion.",
                progression: "Maximal deficit at onset. Many patients recover significantly over weeks to months. Dysphagia may persist."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Attention", severity: .mild, description: "Mild attentional difficulties acutely due to vertigo and discomfort."),
                    CognitiveDomain(domain: "Processing Speed", severity: .minimal, description: "Generally preserved. Cognitive functions largely intact as this is a brainstem stroke.")
                ],
                expectedTestPatterns: [
                    "Neuropsychological profile generally normal (brainstem stroke spares cortex)",
                    "Cranial nerve examination reveals lateralized deficits",
                    "Sensory examination shows characteristic crossed sensory loss pattern"
                ],
                preservedFunctions: [
                    "Higher cortical functions: language, memory, executive function",
                    "Motor strength (corticospinal tract spared)",
                    "Vision",
                    "Intellectual function"
                ],
                differentialConsiderations: [
                    "Vertebral artery dissection: younger patients, neck pain/trauma history",
                    "Cerebellar stroke: prominent ataxia, may progress to brainstem compression",
                    "Vestibular neuritis: vertigo without crossed sensory loss or cranial nerve signs",
                    "Multiple sclerosis: younger, relapsing-remitting course"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "DWI: Restricted diffusion in lateral medulla",
                    "FLAIR: Hyperintensity in posterolateral medulla",
                    "MRA: Vertebral artery or PICA occlusion/dissection"
                ],
                ct: [
                    "CT often normal (posterior fossa poorly visualized on CT)",
                    "CTA: Vertebral artery occlusion may be visible"
                ],
                pet: [
                    "Not typically used for diagnosis"
                ],
                otherModalities: []
            ),
            relatedStructures: ["medulla", "cerebellum"],
            epidemiology: "Most common brainstem stroke syndrome. Accounts for ~2% of all ischemic strokes.",
            etiology: "Posterior inferior cerebellar artery (PICA) or vertebral artery occlusion. Can result from vertebral artery dissection."
        ),

        // MARK: - Psychiatric

        Pathology(
            id: "adhd",
            name: "Attention-Deficit/Hyperactivity Disorder",
            category: .developmental,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Inattention: difficulty sustaining focus, careless mistakes, poor organization",
                    "Hyperactivity: fidgeting, restlessness, excessive talking",
                    "Impulsivity: interrupting, difficulty waiting, hasty decisions",
                    "Executive dysfunction: poor time management, task initiation difficulty",
                    "Emotional dysregulation: frustration intolerance, mood lability",
                    "Presentations: predominantly inattentive, predominantly hyperactive-impulsive, or combined"
                ],
                observableBehaviors: [
                    "Frequently loses items needed for tasks",
                    "Appears not to listen when spoken to directly",
                    "Avoids tasks requiring sustained mental effort",
                    "Shifts between incomplete activities",
                    "Fidgets with hands/feet or squirms in seat",
                    "Blurts out answers before questions are completed"
                ],
                onset: "Symptoms present before age 12. Often recognized in school-age years when demands increase.",
                progression: "Chronic condition. Hyperactivity often decreases with age; inattention and executive dysfunction typically persist into adulthood."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Attention", severity: .moderate, description: "Impaired sustained attention, increased variability in response times. CPT shows omission errors and inconsistent performance."),
                    CognitiveDomain(domain: "Executive Function", severity: .moderate, description: "Impaired response inhibition (go/no-go), set-shifting, planning, and working memory. Core deficit in behavioral regulation."),
                    CognitiveDomain(domain: "Processing Speed", severity: .mild, description: "Variable performance speed. May show slow processing on some measures due to inconsistent engagement."),
                    CognitiveDomain(domain: "Working Memory", severity: .moderate, description: "Both verbal and visuospatial working memory impaired. Digit span backward and spatial span affected.")
                ],
                expectedTestPatterns: [
                    "CPT: Increased omission errors, high response time variability, commission errors",
                    "Digit Span: Forward typically normal, backward impaired",
                    "WCST: Perseverative errors, failure to maintain set",
                    "TMT-B: May be impaired or slow but accurate",
                    "Stroop: Increased interference susceptibility",
                    "CVLT: Disorganized learning strategy but normal total with structure"
                ],
                preservedFunctions: [
                    "Overall intellectual ability (IQ typically normal)",
                    "Long-term memory",
                    "Language abilities",
                    "Visuospatial skills",
                    "Academic knowledge (though underachievement common)"
                ],
                differentialConsiderations: [
                    "Anxiety disorders: inattention from worry, not primary attentional deficit",
                    "Sleep disorders: daytime inattention from poor sleep quality",
                    "Thyroid disorders: restlessness and concentration difficulty",
                    "Learning disabilities: domain-specific vs pervasive attention issues",
                    "Trauma/PTSD: hypervigilance vs hyperactivity"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Reduced prefrontal cortex volume, particularly right prefrontal",
                    "Smaller caudate nucleus volume (normalizes with age in some studies)",
                    "Thinner cortex in frontal and parietal regions",
                    "Delayed cortical maturation pattern (peak thickness ~3 years later)"
                ],
                ct: [
                    "CT not typically used for diagnosis (normal appearance)"
                ],
                pet: [
                    "Reduced frontal and striatal metabolism on FDG-PET",
                    "Reduced dopamine transporter binding in striatum (though variable findings)",
                    "Frontostriatal hypoactivation during executive tasks on fMRI"
                ],
                otherModalities: [
                    ImagingFinding(modality: "fMRI", findings: ["Hypoactivation of prefrontal cortex and anterior cingulate during sustained attention and inhibitory control tasks", "Altered default mode network connectivity"])
                ]
            ),
            relatedStructures: ["prefrontal-cortex", "basal-ganglia-caudate", "cingulate-cortex"],
            epidemiology: "Prevalence ~5-7% in children, ~2.5-4% in adults worldwide. Male:Female ratio ~2:1 in children, ~1.5:1 in adults.",
            etiology: "Highly heritable (~75%). Involves dopamine and norepinephrine dysregulation in frontostriatal circuits. Environmental factors: prenatal tobacco/alcohol exposure, low birth weight.",
            dsm5Criteria: DSM5CriteriaData(
                criterionA: [
                    "Often fails to give close attention to details or makes careless mistakes",
                    "Often has difficulty sustaining attention in tasks or play activities",
                    "Often does not seem to listen when spoken to directly",
                    "Often does not follow through on instructions; fails to finish schoolwork or chores",
                    "Often has difficulty organizing tasks and activities",
                    "Often avoids tasks requiring sustained mental effort",
                    "Often loses things necessary for tasks (pencils, keys, documents)",
                    "Is often easily distracted by extraneous stimuli",
                    "Is often forgetful in daily activities",
                    "Often fidgets with or taps hands/feet or squirms in seat",
                    "Often leaves seat in situations requiring remaining seated",
                    "Often runs about or climbs in situations where inappropriate",
                    "Often unable to play or engage in leisure activities quietly",
                    "Is often 'on the go,' acting as if 'driven by a motor'",
                    "Often talks excessively",
                    "Often blurts out answers before question has been completed",
                    "Often has difficulty waiting their turn",
                    "Often interrupts or intrudes on others"
                ],
                minimumSymptomCount: 6,
                durationRequirement: "≥6 months",
                criterionBCDE: "B: Several symptoms present before age 12. C: Symptoms present in two or more settings. D: Clear evidence symptoms interfere with functioning. E: Not better explained by another disorder.",
                specifiers: [
                    "314.01 (F90.2) — Combined presentation",
                    "314.00 (F90.0) — Predominantly inattentive presentation",
                    "314.01 (F90.1) — Predominantly hyperactive-impulsive presentation",
                    "In partial remission", "Mild / Moderate / Severe"
                ],
                prevalence: "~5% in children, ~2.5% in adults globally."
            )
        ),

        Pathology(
            id: "schizophrenia",
            name: "Schizophrenia",
            category: .psychiatric,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Positive symptoms: hallucinations (auditory most common), delusions, disorganized speech",
                    "Negative symptoms: flat affect, alogia, avolition, anhedonia, social withdrawal",
                    "Cognitive symptoms: impaired attention, working memory, executive function",
                    "Disorganized behavior and thought process",
                    "Impaired insight (anosognosia for illness)",
                    "Catatonia (rare): motor immobility, mutism, posturing"
                ],
                observableBehaviors: [
                    "Responding to internal stimuli (talking to voices)",
                    "Tangential or incoherent speech (word salad)",
                    "Bizarre or paranoid beliefs resistant to evidence",
                    "Social isolation and self-neglect",
                    "Flat or inappropriate emotional responses",
                    "Decline in occupational and social functioning"
                ],
                onset: "Late adolescence to early adulthood (males: late teens/early 20s; females: mid-20s to early 30s). Prodromal phase may precede psychosis.",
                progression: "Chronic with episodic exacerbations. Negative symptoms often worsen over time. Cognitive deficits are relatively stable and trait-like."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Processing Speed", severity: .severe, description: "Most robust and consistent cognitive deficit. Affects performance across all timed measures."),
                    CognitiveDomain(domain: "Working Memory", severity: .moderate, description: "Verbal and spatial working memory impaired. Central executive component most affected."),
                    CognitiveDomain(domain: "Executive Function", severity: .moderate, description: "Impaired planning, set-shifting, abstraction, and cognitive flexibility."),
                    CognitiveDomain(domain: "Verbal Memory", severity: .moderate, description: "Impaired encoding and retrieval. Disorganized learning. Benefits partially from semantic cues."),
                    CognitiveDomain(domain: "Attention", severity: .moderate, description: "Sustained attention and vigilance impaired. Increased attentional capture by irrelevant stimuli.")
                ],
                expectedTestPatterns: [
                    "WAIS Processing Speed Index: ~1 SD below mean",
                    "CVLT: Impaired learning slope, poor recall, benefits from recognition",
                    "WCST: Perseverative errors and categories completed reduced",
                    "TMT-B: Impaired (psychomotor slowing + executive component)",
                    "CPT: Reduced d-prime (sensitivity), increased false alarms",
                    "Letter fluency reduced; category fluency relatively preserved"
                ],
                preservedFunctions: [
                    "Procedural/implicit learning",
                    "Simple sensory perception (when not hallucinating)",
                    "Overlearned skills and crystallized knowledge",
                    "Basic reading and vocabulary (often preserved from premorbid level)"
                ],
                differentialConsiderations: [
                    "Bipolar disorder with psychotic features: episodic course, mood-congruent psychosis",
                    "Substance-induced psychosis: temporal relationship to substance use",
                    "Traumatic brain injury: clear temporal relationship to injury",
                    "Autoimmune encephalitis (anti-NMDA receptor): younger, acute onset, movement abnormalities"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Enlarged lateral ventricles (most replicated finding)",
                    "Reduced total gray matter volume, particularly prefrontal cortex",
                    "Reduced hippocampal volume",
                    "Reduced superior temporal gyrus volume (correlates with hallucinations)",
                    "Reduced cortical thickness in frontal and temporal regions"
                ],
                ct: [
                    "Ventricular enlargement (less sensitive than MRI)",
                    "Sulcal widening suggesting cerebral atrophy"
                ],
                pet: [
                    "Hypofrontality: reduced prefrontal cortex metabolism during cognitive tasks",
                    "Increased D2 receptor binding in striatum (dopamine hypothesis)",
                    "Altered glutamate levels on MRS (magnetic resonance spectroscopy)"
                ],
                otherModalities: [
                    ImagingFinding(modality: "DTI", findings: ["Reduced fractional anisotropy in white matter tracts, particularly arcuate fasciculus and cingulum bundle", "Widespread connectivity disruptions ('disconnection syndrome')"])
                ]
            ),
            relatedStructures: ["prefrontal-cortex", "hippocampus", "superior-temporal-sulcus", "thalamus", "cingulate-cortex"],
            epidemiology: "Lifetime prevalence ~1%. Equal prevalence in males and females. Among top causes of disability worldwide.",
            etiology: "Neurodevelopmental disorder with genetic susceptibility (~80% heritability) and environmental triggers (obstetric complications, urban upbringing, cannabis use). Dopamine, glutamate, and serotonin dysregulation.",
            dsm5Criteria: DSM5CriteriaData(
                criterionA: [
                    "Delusions",
                    "Hallucinations",
                    "Disorganized speech (e.g., frequent derailment or incoherence)",
                    "Grossly disorganized or catatonic behavior",
                    "Negative symptoms (i.e., diminished emotional expression or avolition)"
                ],
                minimumSymptomCount: 2,
                durationRequirement: "≥6 months (including ≥1 month of active-phase symptoms)",
                criterionBCDE: "B: Social/occupational dysfunction for significant portion of time since onset. C: Continuous signs for ≥6 months. D: Not schizoaffective or mood disorder with psychotic features. E: Not due to substance/medical condition. F: Not ASD unless prominent delusions/hallucinations for ≥1 month.",
                specifiers: [
                    "First episode, currently in acute episode",
                    "First episode, currently in partial remission",
                    "Multiple episodes, currently in acute episode",
                    "Continuous", "In remission",
                    "Severity: Hallucinations, Delusions, Disorganization, Negative symptoms (each 0–4 scale)"
                ],
                prevalence: "Lifetime prevalence ~1% globally; equal gender prevalence."
            )
        ),

        Pathology(
            id: "ocd",
            name: "Obsessive-Compulsive Disorder",
            category: .psychiatric,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Obsessions: intrusive, unwanted, recurrent thoughts, images, or urges",
                    "Compulsions: repetitive behaviors or mental acts to reduce obsessional anxiety",
                    "Common themes: contamination, symmetry, harm, taboo thoughts, hoarding",
                    "Time-consuming rituals (>1 hour/day)",
                    "Insight varies from good to absent",
                    "Avoidance of triggers"
                ],
                observableBehaviors: [
                    "Excessive hand washing, cleaning, or checking",
                    "Ordering and arranging objects precisely",
                    "Counting, tapping, or repeating actions a specific number of times",
                    "Seeking reassurance repeatedly",
                    "Mental rituals (praying, reviewing, neutralizing)",
                    "Avoidance of situations that trigger obsessions"
                ],
                onset: "Bimodal onset: childhood (8-12 years) and late adolescence/early adulthood. Mean age ~19.",
                progression: "Chronic waxing and waning course. Symptoms may worsen with stress. Treatment-responsive (CBT/ERP + SSRIs)."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Executive Function", severity: .mild, description: "Impaired set-shifting, planning, and response inhibition. Difficulty disengaging from prepotent responses."),
                    CognitiveDomain(domain: "Processing Speed", severity: .mild, description: "Slowness due to checking and doubting rather than true processing speed deficit."),
                    CognitiveDomain(domain: "Memory", severity: .mild, description: "Memory confidence impaired more than memory ability. Excessive checking reflects metamemory deficit.")
                ],
                expectedTestPatterns: [
                    "WCST: May show perseverative errors (difficulty shifting)",
                    "Rey Complex Figure: Overly detailed, fragmented copy style; slow but accurate",
                    "CVLT: May show organizational deficits but adequate total learning",
                    "Stroop: Mild interference effect",
                    "Tower of London: Increased planning time, more moves needed"
                ],
                preservedFunctions: [
                    "General intelligence typically normal to above average",
                    "Language abilities intact",
                    "Visuospatial abilities (may show excessive attention to detail)",
                    "Long-term memory storage",
                    "Attention (when not competing with obsessional content)"
                ],
                differentialConsiderations: [
                    "Generalized anxiety disorder: worry vs obsession, no compulsions",
                    "Body dysmorphic disorder: obsessions focused on perceived appearance flaws",
                    "Tourette syndrome: often comorbid, tics vs compulsions",
                    "Autism spectrum: repetitive behaviors are ego-syntonic, not distressing"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Increased volume of caudate nucleus (some studies)",
                    "Reduced orbitofrontal cortex volume",
                    "Altered cingulate cortex morphology"
                ],
                ct: [
                    "Typically normal on CT (not primary diagnostic tool)"
                ],
                pet: [
                    "Increased metabolic activity in orbitofrontal cortex, caudate nucleus, and anterior cingulate (cortico-striato-thalamo-cortical circuit hyperactivity)",
                    "Normalizes with successful treatment (both CBT and SSRIs)",
                    "Symptom provocation paradigms show OFC/caudate activation increase"
                ],
                otherModalities: [
                    ImagingFinding(modality: "fMRI", findings: ["Hyperactivation of orbitofrontal-striatal-thalamic circuit during symptom provocation", "Error-related negativity (ERN) increased on EEG, reflecting hyperactive error monitoring"])
                ]
            ),
            relatedStructures: ["orbitofrontal-cortex", "basal-ganglia-caudate", "cingulate-cortex", "thalamus"],
            epidemiology: "Lifetime prevalence ~2-3%. Equal in males and females (males have earlier onset). Often comorbid with depression and anxiety.",
            etiology: "Dysregulation of cortico-striato-thalamo-cortical (CSTC) circuits. Serotonin and glutamate involvement. Genetic factors (~40-50% heritability).",
            dsm5Criteria: DSM5CriteriaData(
                criterionA: [
                    "Presence of obsessions, compulsions, or both",
                    "Obsessions: recurrent, persistent thoughts/urges/images experienced as intrusive and unwanted, causing anxiety",
                    "Individual attempts to ignore, suppress, or neutralize obsessions with compulsions",
                    "Compulsions: repetitive behaviors (hand washing, ordering, checking) or mental acts (praying, counting, repeating)",
                    "Compulsions aimed at preventing/reducing anxiety or preventing dreaded event",
                    "Obsessions/compulsions are time-consuming (>1 hour/day)"
                ],
                minimumSymptomCount: nil,
                durationRequirement: "Time-consuming (>1 hour/day) or cause clinically significant distress",
                criterionBCDE: "B: Obsessions/compulsions are time-consuming or cause significant distress/impairment. C: Not due to substance or medical condition. D: Not better explained by another mental disorder. Specify insight: good/fair, poor, or absent/delusional.",
                specifiers: [
                    "With good or fair insight",
                    "With poor insight",
                    "With absent insight/delusional beliefs",
                    "Tic-related"
                ],
                prevalence: "12-month prevalence ~1.2%; lifetime ~2–3%. Slightly higher in females in adulthood."
            )
        ),

        Pathology(
            id: "ptsd",
            name: "Post-Traumatic Stress Disorder",
            category: .psychiatric,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Re-experiencing: intrusive memories, flashbacks, nightmares",
                    "Avoidance: avoiding reminders of the trauma",
                    "Negative cognitions: guilt, shame, distorted blame, emotional numbing",
                    "Hyperarousal: hypervigilance, exaggerated startle, sleep disturbance, irritability",
                    "Dissociative symptoms (depersonalization/derealization in some)",
                    "Difficulty concentrating and memory problems"
                ],
                observableBehaviors: [
                    "Startle response to unexpected stimuli",
                    "Scanning environment for threats (hypervigilance)",
                    "Emotional numbing and social withdrawal",
                    "Irritability and anger outbursts",
                    "Avoidance of places, people, or activities associated with trauma",
                    "Sleep disturbance and nightmares"
                ],
                onset: "After exposure to actual or threatened death, serious injury, or sexual violence. Symptoms begin within 3 months (can be delayed onset).",
                progression: "Variable course. ~50% recover within 3 months; ~30% develop chronic PTSD. Treatment-responsive (CPT, PE, EMDR)."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Attention", severity: .moderate, description: "Attentional bias toward threat cues. Difficulty with sustained attention and concentration. Easily distracted by trauma-related stimuli."),
                    CognitiveDomain(domain: "Memory", severity: .moderate, description: "Fragmented trauma memories. Impaired verbal declarative memory. Hippocampal-dependent learning affected."),
                    CognitiveDomain(domain: "Executive Function", severity: .mild, description: "Reduced inhibitory control, impaired working memory updating, difficulty with cognitive flexibility.")
                ],
                expectedTestPatterns: [
                    "CVLT: Reduced learning and recall, may show intrusion errors",
                    "CPT: Increased omission and commission errors (attentional inconsistency)",
                    "Stroop: Increased interference, particularly with trauma-related words (emotional Stroop)",
                    "Digit Span: May show reduced backward span (working memory)",
                    "Performance anxiety and test-taking distress may affect all scores"
                ],
                preservedFunctions: [
                    "General intellectual functioning typically intact",
                    "Language abilities",
                    "Visuospatial skills",
                    "Procedural memory",
                    "Overlearned skills and crystallized knowledge"
                ],
                differentialConsiderations: [
                    "Acute stress disorder: symptoms within 1 month of trauma",
                    "Adjustment disorder: subthreshold symptoms, broader stressor types",
                    "TBI with PTSD: overlapping symptoms, need careful history",
                    "Depression: overlapping concentration and memory complaints"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Reduced hippocampal volume (most replicated structural finding)",
                    "Reduced anterior cingulate cortex volume",
                    "Reduced medial prefrontal cortex volume"
                ],
                ct: [
                    "CT typically normal (not primary diagnostic modality)"
                ],
                pet: [
                    "Amygdala hyperactivation to threat stimuli",
                    "Medial prefrontal cortex hypoactivation (reduced top-down regulation)",
                    "Hippocampal hypoactivation during memory tasks"
                ],
                otherModalities: [
                    ImagingFinding(modality: "fMRI", findings: ["Amygdala hyperreactivity to threat cues", "Reduced medial PFC activation (impaired fear extinction)", "Altered default mode network connectivity"])
                ]
            ),
            relatedStructures: ["amygdala", "hippocampus", "prefrontal-cortex", "cingulate-cortex"],
            epidemiology: "Lifetime prevalence ~6-8% in US. Higher in women (~2x) and military/first responder populations.",
            etiology: "Trauma exposure with failure of fear extinction learning. Amygdala-prefrontal circuit dysregulation. HPA axis abnormalities (low cortisol). Genetic vulnerability (~30% heritability).",
            dsm5Criteria: DSM5CriteriaData(
                criterionA: [
                    "A: Exposure to actual or threatened death, serious injury, or sexual violence (directly, witnessing, learning of event in close person, or extreme/repeated exposure)",
                    "B1: Intrusive memories — spontaneous, distressing recollections",
                    "B2: Dissociative flashback episodes",
                    "B3: Distressing dreams related to traumatic event",
                    "B4: Intense psychological distress to trauma cues",
                    "B5: Physiological reactions to trauma-related cues",
                    "C1: Avoidance of distressing thoughts or feelings",
                    "C2: Avoidance of external reminders (people, places, activities)",
                    "D1: Inability to remember key aspect of traumatic event",
                    "D2: Persistent negative beliefs about self or world",
                    "D3: Distorted blame of self/others for traumatic event",
                    "D4: Persistent negative emotional states",
                    "D5: Diminished interest in activities",
                    "D6: Detachment or estrangement from others",
                    "D7: Inability to experience positive emotions",
                    "E1: Hypervigilance",
                    "E2: Exaggerated startle response",
                    "E3: Irritable behavior and angry outbursts",
                    "E4: Reckless or self-destructive behavior",
                    "E5: Problems with concentration",
                    "E6: Sleep disturbance"
                ],
                minimumSymptomCount: nil,
                durationRequirement: "≥1 month (Criterion B: ≥1, C: ≥1, D: ≥2, E: ≥2)",
                criterionBCDE: "F: Significant distress or impairment in functioning. G: Not due to substance or medical condition. Specify: with dissociative symptoms (depersonalization/derealization); with delayed expression (≥6 months after event).",
                specifiers: [
                    "With dissociative symptoms: depersonalization",
                    "With dissociative symptoms: derealization",
                    "With delayed expression (full criteria not met until ≥6 months post-event)"
                ],
                prevalence: "12-month prevalence ~3.5% in US adults; lifetime ~6–8%."
            )
        ),

        // MARK: - Aphasias & Language Syndromes

        Pathology(
            id: "brocas-aphasia",
            name: "Broca's Aphasia",
            category: .syndromic,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Non-fluent, effortful, halting speech",
                    "Telegraphic speech (content words, omitting function words)",
                    "Agrammatism (impaired syntax)",
                    "Relatively preserved auditory comprehension",
                    "Impaired repetition",
                    "Often accompanied by right hemiparesis (face and arm)"
                ],
                observableBehaviors: [
                    "Visible effort and frustration when speaking",
                    "Speaks in short phrases of 1-4 words",
                    "Omits articles, prepositions, and verb inflections",
                    "Articulation may be impaired (speech apraxia component)",
                    "Aware of errors, attempts self-correction",
                    "May use gestures to compensate"
                ],
                onset: "Sudden (stroke) or progressive (primary progressive aphasia, nonfluent variant).",
                progression: "Stroke: may improve with speech therapy over months. Some recovery of fluency but agrammatism often persists."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Expressive Language", severity: .severe, description: "Severely reduced verbal output, agrammatism, impaired repetition. Writing also affected (similar errors)."),
                    CognitiveDomain(domain: "Receptive Language", severity: .mild, description: "Relatively preserved for simple commands. Impaired for syntactically complex sentences (e.g., passive voice)."),
                    CognitiveDomain(domain: "Motor/Praxis", severity: .moderate, description: "Often co-occurring oral/speech apraxia and right-sided motor deficits.")
                ],
                expectedTestPatterns: [
                    "WAB/BDAE: Low fluency scores, relatively preserved comprehension, impaired repetition",
                    "Boston Naming Test: Impaired (tip-of-tongue phenomenon, phonemic paraphasias)",
                    "Verbal fluency: Severely reduced (both letter and category)",
                    "Token Test: May be mildly impaired for complex commands",
                    "Non-verbal cognitive abilities may be relatively preserved"
                ],
                preservedFunctions: [
                    "Auditory comprehension of simple messages",
                    "Non-verbal intelligence",
                    "Visuospatial abilities (if right hemisphere intact)",
                    "Singing of familiar songs (often spared)",
                    "Automatic/overlearned speech (counting, days of the week)"
                ],
                differentialConsiderations: [
                    "Transcortical motor aphasia: similar but repetition is preserved",
                    "Speech apraxia: motor programming deficit without language impairment",
                    "Dysarthria: slurred speech from motor weakness, not language disorder",
                    "Nonfluent/agrammatic PPA: progressive, neurodegenerative etiology"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Lesion in left inferior frontal gyrus (pars opercularis and triangularis, BA44/45)",
                    "Often extends to adjacent insular cortex and underlying white matter",
                    "DWI/FLAIR hyperintensity in left frontal operculum (acute stroke)"
                ],
                ct: [
                    "Hypodensity in left frontal opercular region (established infarct)",
                    "Early signs of MCA territory infarction"
                ],
                pet: [
                    "Reduced metabolic activity in left inferior frontal region",
                    "May show perilesional hypometabolism extending beyond structural lesion"
                ],
                otherModalities: []
            ),
            relatedStructures: ["brocas-area", "primary-motor-cortex", "supplementary-motor-area"],
            epidemiology: "Most common motor aphasia type. Typically results from left MCA superior division stroke.",
            etiology: "Left inferior frontal gyrus (Broca's area) lesion, most commonly from ischemic stroke."
        ),

        Pathology(
            id: "wernickes-aphasia",
            name: "Wernicke's Aphasia",
            category: .syndromic,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Fluent but meaningless speech (logorrhea)",
                    "Paraphasias: semantic (table -> chair) and phonemic (table -> tabel)",
                    "Neologisms (invented words) and jargon",
                    "Severely impaired auditory comprehension",
                    "Impaired repetition",
                    "Poor awareness of language deficits (anosognosia)",
                    "Reading and writing similarly impaired"
                ],
                observableBehaviors: [
                    "Speaks at normal or increased rate with proper prosody",
                    "Speech sounds fluent but lacks content (empty speech)",
                    "Does not follow verbal commands accurately",
                    "May become frustrated or paranoid when not understood",
                    "No accompanying hemiparesis (unlike Broca's)",
                    "May initially be mistaken for psychosis or confusion"
                ],
                onset: "Sudden (stroke, typically left MCA inferior division).",
                progression: "Variable recovery. Some improve significantly; pure word deafness or anomic aphasia may be residual states."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Receptive Language", severity: .severe, description: "Severely impaired auditory comprehension. Cannot follow commands or understand spoken language."),
                    CognitiveDomain(domain: "Expressive Language", severity: .severe, description: "Fluent but empty speech with paraphasias, neologisms, and circumlocutions. Impaired naming and repetition."),
                    CognitiveDomain(domain: "Reading/Writing", severity: .severe, description: "Alexia and agraphia. Written output shows similar errors to spoken language.")
                ],
                expectedTestPatterns: [
                    "WAB/BDAE: High fluency, very low comprehension, impaired repetition, impaired naming",
                    "Token Test: Severely impaired",
                    "Boston Naming Test: Severely impaired with semantic and phonemic paraphasias",
                    "Testing challenging due to comprehension deficit — non-verbal tests needed",
                    "Pointing/matching tasks may reveal some preserved comprehension"
                ],
                preservedFunctions: [
                    "Speech prosody and fluency",
                    "Non-verbal cognition (when properly assessed)",
                    "Motor function (typically no hemiparesis)",
                    "Visuospatial abilities",
                    "Automatic speech and social greetings"
                ],
                differentialConsiderations: [
                    "Transcortical sensory aphasia: similar but repetition is preserved",
                    "Delirium/confusion: global cognitive impairment, fluctuating course",
                    "Psychosis: thought disorder vs language disorder",
                    "Semantic variant PPA: progressive, anterior temporal focus"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Lesion in left posterior superior temporal gyrus (BA22)",
                    "May extend to left inferior parietal lobule",
                    "DWI restricted diffusion in left temporal-parietal region (acute)"
                ],
                ct: [
                    "Hypodensity in left posterior temporal region (established infarct)",
                    "Left MCA inferior division territory involvement"
                ],
                pet: [
                    "Reduced metabolic activity in left posterior temporal region",
                    "May show widespread left hemisphere hypometabolism"
                ],
                otherModalities: []
            ),
            relatedStructures: ["wernickes-area", "angular-gyrus", "parietal-inferior"],
            epidemiology: "Most common fluent aphasia type. Results from left MCA inferior division stroke.",
            etiology: "Left posterior superior temporal gyrus (Wernicke's area) lesion, typically from ischemic stroke."
        ),

        // MARK: - Agnosias & Perceptual Disorders

        Pathology(
            id: "prosopagnosia",
            name: "Prosopagnosia (Face Blindness)",
            category: .syndromic,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Inability to recognize familiar faces",
                    "May fail to recognize family members, friends, or own face",
                    "Intact recognition of people by voice, gait, or context",
                    "Intact low-level visual perception",
                    "May be acquired (brain injury) or developmental",
                    "Emotional recognition from faces may be impaired or spared"
                ],
                observableBehaviors: [
                    "Does not greet familiar people in unexpected contexts",
                    "Relies on hairstyle, clothing, voice, or context to identify people",
                    "May not recognize self in photos or mirrors",
                    "Social anxiety and avoidance due to recognition failures",
                    "Compensatory strategies: asking names, waiting for voices"
                ],
                onset: "Acquired: sudden (stroke, trauma) or progressive (neurodegeneration). Developmental: lifelong.",
                progression: "Acquired: may partially recover. Developmental: stable, lifelong."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Face Perception", severity: .severe, description: "Cannot match or recognize faces. Benton Face Recognition Test impaired. Face-specific deficit."),
                    CognitiveDomain(domain: "Object Recognition", severity: .variable, description: "May be intact (face-specific) or impaired (associative visual agnosia with prosopagnosia).")
                ],
                expectedTestPatterns: [
                    "Benton Facial Recognition Test: Impaired",
                    "Famous Faces Test: Severely impaired (cannot name or provide semantic information)",
                    "Face matching tasks: May be impaired (apperceptive) or intact (associative)",
                    "Object recognition: Variable — may be intact (pure prosopagnosia)",
                    "Emotion recognition from faces: Variable"
                ],
                preservedFunctions: [
                    "Visual acuity and basic visual perception",
                    "Person recognition through non-face cues (voice, gait)",
                    "Object recognition (often preserved)",
                    "General cognitive abilities",
                    "Covert face recognition (GSR may show recognition without awareness)"
                ],
                differentialConsiderations: [
                    "Social anxiety: avoidance but intact face recognition ability",
                    "Capgras delusion: believes familiar person replaced by impostor",
                    "Alzheimer's disease: broader cognitive decline",
                    "Autism spectrum: may have face processing difficulty in social cognition context"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Lesion in right fusiform gyrus (fusiform face area, FFA)",
                    "May involve bilateral occipitotemporal cortex",
                    "Developmental: subtle structural differences in fusiform region on volumetric analysis"
                ],
                ct: [
                    "May show right posterior temporal/occipital lesion in acquired cases"
                ],
                pet: [
                    "Reduced activation in fusiform face area during face viewing on fMRI",
                    "Developmental cases show atypical face processing network activation"
                ],
                otherModalities: [
                    ImagingFinding(modality: "fMRI", findings: ["Absent or reduced FFA activation to faces", "May show object-area activation for face stimuli (atypical processing)"])
                ]
            ),
            relatedStructures: ["fusiform-gyrus", "inferior-temporal-cortex", "visual-association"],
            epidemiology: "Acquired prosopagnosia is rare. Developmental prosopagnosia affects ~2.5% of the population.",
            etiology: "Acquired: damage to right or bilateral fusiform gyrus (stroke, trauma, surgery). Developmental: genetic factors, altered connectivity in face processing network."
        ),

        Pathology(
            id: "hemispatial-neglect",
            name: "Hemispatial Neglect",
            category: .syndromic,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Failure to attend, respond, or orient to stimuli on the contralesional side",
                    "Not explained by primary sensory or motor deficits",
                    "Most common and severe after right hemisphere lesions (left neglect)",
                    "May affect personal space (body), peripersonal space, or extrapersonal space",
                    "Often accompanied by anosognosia (unawareness of deficit)",
                    "Extinction: misses contralateral stimulus only during bilateral simultaneous stimulation"
                ],
                observableBehaviors: [
                    "Only eats food from right side of plate",
                    "Shaves/applies makeup only on right side",
                    "Draws only the right side of objects (clock, flower)",
                    "Reads only right portion of words or text",
                    "Bumps into objects on left side",
                    "Denies any deficit when confronted"
                ],
                onset: "Acute (stroke). May also occur with tumors, TBI, or degenerative conditions.",
                progression: "Often improves over weeks to months. Complete recovery is less common with larger right hemisphere lesions."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Spatial Attention", severity: .severe, description: "Failure to allocate attention to contralesional space. Affects all sensory modalities."),
                    CognitiveDomain(domain: "Visuospatial", severity: .severe, description: "Impaired spatial representation, line bisection deviation, constructional deficits with left-sided omissions."),
                    CognitiveDomain(domain: "Awareness", severity: .severe, description: "Anosognosia — lack of awareness of neglect and often of left-sided hemiparesis.")
                ],
                expectedTestPatterns: [
                    "Line bisection: Rightward deviation (marks midpoint right of center)",
                    "Star/letter cancellation: Left-sided omissions",
                    "Clock drawing: Numbers compressed on right side, left side empty",
                    "Figure copy: Left-sided details omitted",
                    "Reading: Left-sided neglect dyslexia (reads only right part of words/lines)",
                    "Behavioral Inattention Test (BIT): Below cutoff"
                ],
                preservedFunctions: [
                    "Right-sided spatial processing",
                    "Language (usually, unless left hemisphere also affected)",
                    "Memory (when material is properly attended to)",
                    "Executive function (when spatial component removed)"
                ],
                differentialConsiderations: [
                    "Homonymous hemianopia: visual field cut but patients compensate by turning head",
                    "Extinction: milder form, only appears with bilateral stimulation",
                    "Motor neglect: failure to use contralateral limb despite intact strength",
                    "Depression/apathy: bilateral inattention, not lateralized"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Right inferior parietal lobule (supramarginal gyrus) lesion — most common",
                    "Right temporoparietal junction (TPJ) involvement",
                    "Right superior temporal gyrus lesions associated with severe neglect",
                    "Right frontal lesions can cause neglect (motor neglect variant)"
                ],
                ct: [
                    "Right MCA territory infarction",
                    "Right parietal or temporal hypodensity"
                ],
                pet: [
                    "Reduced right parietal and frontal metabolism",
                    "Interhemispheric imbalance favoring left hemisphere activation"
                ],
                otherModalities: []
            ),
            relatedStructures: ["parietal-inferior", "parietal-superior", "superior-temporal-sulcus", "prefrontal-cortex"],
            epidemiology: "Occurs in ~25-30% of right hemisphere stroke patients acutely. Left neglect (from right hemisphere damage) is far more common and severe than right neglect.",
            etiology: "Right hemisphere lesion disrupting spatial attention networks. Most commonly right MCA territory ischemic stroke involving parietal or temporal cortex."
        ),

        // MARK: - Epileptic

        Pathology(
            id: "temporal-lobe-epilepsy",
            name: "Temporal Lobe Epilepsy",
            category: .epileptic,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Focal seizures with dyscognitive features (formerly complex partial)",
                    "Aura: rising epigastric sensation, deja vu, fear, olfactory hallucinations",
                    "Automatisms: lip smacking, hand rubbing, swallowing",
                    "Post-ictal confusion and aphasia (if left temporal)",
                    "Possible secondary generalization (tonic-clonic)",
                    "Interictal behavioral/personality changes (Geschwind syndrome)"
                ],
                observableBehaviors: [
                    "Staring spells with loss of awareness (30-90 seconds)",
                    "Repetitive movements (automatisms) during seizure",
                    "Confusion and disorientation after seizures",
                    "Reports unusual sensory experiences (auras)",
                    "May have hypergraphia, hyperreligiosity, altered sexuality (interictal)",
                    "Memory complaints and cognitive difficulties"
                ],
                onset: "Often begins in childhood or adolescence. History of febrile seizures is common risk factor.",
                progression: "Chronic condition. May become refractory to medications. Surgical resection curative in ~60-80% of mesial TLE."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Memory", severity: .moderate, description: "Left TLE: Impaired verbal memory (word lists, stories). Right TLE: Impaired visual/spatial memory (faces, designs). Material-specific lateralization."),
                    CognitiveDomain(domain: "Language", severity: .mild, description: "Left TLE may show impaired naming, reduced verbal fluency, and word-finding difficulty."),
                    CognitiveDomain(domain: "Executive Function", severity: .mild, description: "May be impaired due to propagation of seizure activity to frontal lobes or medication effects.")
                ],
                expectedTestPatterns: [
                    "Left TLE: CVLT/story memory impaired; visual memory relatively preserved",
                    "Right TLE: Rey Complex Figure delayed recall impaired; verbal memory relatively preserved",
                    "Boston Naming Test: May be impaired in left TLE",
                    "Wada test or fMRI for language lateralization pre-surgery",
                    "Intracarotid amobarbital (Wada) procedure for memory lateralization pre-surgery",
                    "Neuropsych pre/post surgical comparison critical"
                ],
                preservedFunctions: [
                    "General intellectual ability usually preserved",
                    "Contralateral material-specific memory (left TLE: visual; right TLE: verbal)",
                    "Motor functions",
                    "Basic attention (interictal)",
                    "Visuospatial abilities (unless right temporal)"
                ],
                differentialConsiderations: [
                    "Psychogenic nonepileptic seizures: no EEG correlate, often preserved awareness",
                    "Frontal lobe epilepsy: brief nocturnal seizures, bizarre motor phenomena",
                    "Transient epileptic amnesia: episodes of isolated amnesia",
                    "Dissociative disorders: altered consciousness without EEG changes"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Hippocampal sclerosis: reduced hippocampal volume and increased T2/FLAIR signal",
                    "Loss of internal hippocampal architecture",
                    "May show temporal lobe atrophy ipsilateral to seizure focus",
                    "3T MRI with epilepsy protocol optimizes detection"
                ],
                ct: [
                    "CT often normal (insensitive for hippocampal sclerosis)",
                    "May show temporal lobe calcification or tumor"
                ],
                pet: [
                    "Interictal FDG-PET: Temporal lobe hypometabolism ipsilateral to seizure focus",
                    "Ictal SPECT: Temporal lobe hyperperfusion during seizure",
                    "PET lateralizes seizure focus in 70-80% of cases"
                ],
                otherModalities: [
                    ImagingFinding(modality: "EEG", findings: ["Interictal: Anterior temporal sharp waves or spikes", "Ictal: Rhythmic temporal theta activity", "Video-EEG monitoring for seizure characterization and lateralization"]),
                    ImagingFinding(modality: "MEG", findings: ["Magnetoencephalography for presurgical localization of epileptiform activity"])
                ]
            ),
            relatedStructures: ["hippocampus", "amygdala", "inferior-temporal-cortex", "fusiform-gyrus"],
            epidemiology: "Most common form of focal epilepsy. Mesial temporal lobe epilepsy (MTLE) accounts for ~60% of temporal lobe epilepsy cases.",
            etiology: "Mesial temporal sclerosis (hippocampal sclerosis) most common cause. Other causes: tumors, vascular malformations, cortical dysplasia, encephalitis."
        ),

        // MARK: - Metabolic

        Pathology(
            id: "korsakoff-syndrome",
            name: "Korsakoff Syndrome",
            category: .metabolic,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Profound anterograde amnesia (inability to form new memories)",
                    "Retrograde amnesia with temporal gradient (recent > remote)",
                    "Confabulation (fabrication of memories without intent to deceive)",
                    "Lack of insight into memory deficit",
                    "Apathy and emotional blunting",
                    "Often follows Wernicke encephalopathy (confusion, ataxia, ophthalmoplegia)"
                ],
                observableBehaviors: [
                    "Repeats same questions within minutes without recollection",
                    "Fills memory gaps with plausible but false narratives (confabulation)",
                    "Cannot learn new information despite normal conversation",
                    "Appears socially appropriate but content is inconsistent",
                    "Cannot recall recent visitors or events",
                    "Lacks concern about memory failures"
                ],
                onset: "Typically develops after untreated Wernicke encephalopathy. Chronic alcohol use is most common cause.",
                progression: "Persistent once established. ~25% recover partially with thiamine treatment and abstinence. Most have chronic memory impairment."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Episodic Memory", severity: .severe, description: "Profound anterograde amnesia. Cannot form new declarative memories. Retrograde amnesia with temporal gradient."),
                    CognitiveDomain(domain: "Executive Function", severity: .moderate, description: "Impaired planning, temporal ordering, source monitoring. Contributes to confabulation."),
                    CognitiveDomain(domain: "Metamemory", severity: .severe, description: "Poor insight into memory deficit. Cannot judge own learning or memory performance.")
                ],
                expectedTestPatterns: [
                    "WMS: Severely impaired delayed recall (both verbal and visual)",
                    "CVLT: Flat learning curve, near-zero delayed recall, poor recognition",
                    "Preserved digit span (immediate/working memory intact)",
                    "Intact procedural learning (mirror tracing, rotary pursuit)",
                    "WCST: Perseverative errors (executive dysfunction)",
                    "Priming tasks: Intact (implicit memory preserved)"
                ],
                preservedFunctions: [
                    "Immediate memory/working memory (digit span normal)",
                    "Procedural/skill memory",
                    "Implicit memory and priming",
                    "General intellectual ability (IQ often preserved)",
                    "Language and visuospatial skills",
                    "Remote memories (distant past relatively preserved)"
                ],
                differentialConsiderations: [
                    "Alzheimer's disease: encoding deficit (recognition also impaired), broader cognitive decline",
                    "Herpes simplex encephalitis amnesia: temporal lobe lesions, more severe retrograde amnesia",
                    "Transient global amnesia: temporary, fully resolves",
                    "Psychogenic amnesia: loss of personal identity, inconsistent presentation"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Mammillary body atrophy (most characteristic finding)",
                    "Medial thalamic atrophy (anterior and mediodorsal nuclei)",
                    "Periventricular and periaqueductal signal changes (Wernicke phase)",
                    "Cerebellar vermis atrophy"
                ],
                ct: [
                    "May show mammillary body atrophy (less sensitive than MRI)",
                    "Generalized cerebral atrophy and cerebellar atrophy"
                ],
                pet: [
                    "Reduced thalamic and frontal metabolism on FDG-PET",
                    "Widespread cortical hypometabolism in advanced cases"
                ],
                otherModalities: []
            ),
            relatedStructures: ["mammillary-bodies", "thalamus", "hippocampus", "fornix"],
            epidemiology: "Occurs in ~12.5% of chronic alcohol users. Often underdiagnosed. Prevalence in alcohol-dependent populations estimated at 10-12%.",
            etiology: "Thiamine (vitamin B1) deficiency, most commonly from chronic alcoholism. Also occurs with malnutrition, bariatric surgery, prolonged vomiting, or hyperemesis gravidarum."
        ),

        // MARK: - Developmental/Autism

        Pathology(
            id: "autism-spectrum",
            name: "Autism Spectrum Disorder",
            category: .developmental,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Persistent deficits in social communication and interaction",
                    "Restricted, repetitive patterns of behavior, interests, or activities",
                    "Reduced social-emotional reciprocity",
                    "Deficits in nonverbal communication (eye contact, gestures, facial expression)",
                    "Difficulty developing and maintaining relationships",
                    "Sensory hyper- or hypo-reactivity"
                ],
                observableBehaviors: [
                    "Limited eye contact and joint attention",
                    "Repetitive motor movements (hand flapping, rocking)",
                    "Insistence on sameness and rigid routines",
                    "Intense, focused interests on specific topics",
                    "Literal interpretation of language, difficulty with sarcasm/idioms",
                    "Difficulty reading social cues and taking others' perspectives"
                ],
                onset: "Symptoms present in early developmental period (before age 3), though may not be recognized until demands exceed capacity.",
                progression: "Lifelong neurodevelopmental condition. Adaptive functioning varies widely. Many develop compensatory strategies. Outcomes improved with early intervention."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Social Cognition", severity: .severe, description: "Impaired theory of mind, emotion recognition, social perception, and pragmatic language."),
                    CognitiveDomain(domain: "Executive Function", severity: .moderate, description: "Cognitive inflexibility, difficulty with set-shifting. Planning may be impaired. Weak central coherence (detail-focused processing)."),
                    CognitiveDomain(domain: "Language/Pragmatics", severity: .variable, description: "Range from nonverbal to advanced vocabulary. Pragmatic language (social use) universally affected. Prosody may be atypical.")
                ],
                expectedTestPatterns: [
                    "ADOS-2/ADI-R: Diagnostic assessment showing social communication deficits",
                    "Reading the Mind in the Eyes Test: Impaired (theory of mind)",
                    "WCST: Perseverative errors (cognitive inflexibility)",
                    "Embedded Figures Test: Often superior (detail-focused processing)",
                    "Block Design: May be relatively strong (local processing)",
                    "IQ profile: May show significant V-P discrepancy in either direction"
                ],
                preservedFunctions: [
                    "Rote memory (often excellent)",
                    "Systemizing and pattern recognition",
                    "Visual-spatial skills (often strong)",
                    "Factual knowledge in areas of interest",
                    "Attention to detail",
                    "Procedural learning"
                ],
                differentialConsiderations: [
                    "Social communication disorder: pragmatic deficits without restricted/repetitive behaviors",
                    "ADHD: attention and impulsivity without core social communication deficit",
                    "Intellectual disability: global delays, social skills commensurate with cognitive level",
                    "Social anxiety: desire for social interaction but avoidance due to fear"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Early brain overgrowth in first 2 years followed by normalization",
                    "Atypical minicolumnar organization",
                    "Reduced volume of superior temporal sulcus region",
                    "Altered amygdala volume (enlarged in childhood, normalized or reduced by adulthood)"
                ],
                ct: [
                    "CT typically normal (not primary diagnostic tool)"
                ],
                pet: [
                    "Reduced serotonin synthesis in cortex",
                    "Atypical activation of face processing network (FFA, STS)"
                ],
                otherModalities: [
                    ImagingFinding(modality: "fMRI", findings: ["Reduced activation in STS, fusiform face area, and mirror neuron system during social tasks", "Reduced long-range connectivity and increased local connectivity", "Atypical default mode network function"]),
                    ImagingFinding(modality: "DTI", findings: ["Altered white matter integrity in social brain pathways", "Reduced fractional anisotropy in arcuate fasciculus and corpus callosum"])
                ]
            ),
            relatedStructures: ["superior-temporal-sulcus", "fusiform-gyrus", "amygdala", "prefrontal-cortex", "corpus-callosum"],
            epidemiology: "Prevalence ~1 in 36 children (CDC 2023 data). Male:Female ratio ~4:1 (likely under-diagnosis in females). All racial and socioeconomic groups.",
            etiology: "Highly heritable (~80%). Polygenetic with hundreds of risk genes. Prenatal environmental factors (advanced parental age, prenatal infections, valproate exposure). Altered neural connectivity and synaptic function.",
            dsm5Criteria: DSM5CriteriaData(
                criterionA: [
                    "Deficits in social-emotional reciprocity (reduced sharing of interests, emotions, or affect; failure of normal back-and-forth conversation)",
                    "Deficits in nonverbal communicative behaviors (poorly integrated verbal/nonverbal communication; abnormalities in eye contact and body language)",
                    "Deficits in developing, maintaining, and understanding relationships (difficulties adjusting behavior to social contexts; absence of interest in peers)"
                ],
                minimumSymptomCount: nil,
                durationRequirement: "Symptoms present in early developmental period (may not fully manifest until social demands exceed limited capacities)",
                criterionBCDE: "B: ≥2 of 4 restricted/repetitive behaviors: (1) stereotyped motor/speech/object use, (2) insistence on sameness, (3) highly restricted fixated interests, (4) hyper/hyporeactivity to sensory input. C: Symptoms present in early developmental period. D: Symptoms cause significant impairment. E: Not better explained by intellectual disability or global developmental delay.",
                specifiers: [
                    "With or without accompanying intellectual impairment",
                    "With or without accompanying language impairment",
                    "Associated with known medical/genetic condition",
                    "Associated with another neurodevelopmental/mental disorder",
                    "With catatonia",
                    "Severity Level 1 (requires support), Level 2 (requires substantial support), Level 3 (requires very substantial support)"
                ],
                prevalence: "~2.8% in US children; ~1 in 36 (CDC 2023). 4:1 male to female ratio."
            )
        ),

        // MARK: - Additional Syndromes

        Pathology(
            id: "kluver-bucy",
            name: "Kluver-Bucy Syndrome",
            category: .syndromic,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Visual agnosia (psychic blindness — inability to recognize objects visually)",
                    "Hyperorality (tendency to examine objects with mouth)",
                    "Hypersexuality (inappropriate sexual behavior)",
                    "Emotional flatness (absence of normal fear and anger responses)",
                    "Hypermetamorphosis (compulsive attention to visual stimuli)",
                    "Dietary changes (will eat non-food objects)"
                ],
                observableBehaviors: [
                    "Attempts to put non-food objects in mouth",
                    "Approaches dangerous situations without fear",
                    "Inappropriate sexual behavior toward objects or people",
                    "Picks up and examines every visible object compulsively",
                    "Does not recognize previously familiar objects or people",
                    "Placid and compliant despite inappropriate stimulation"
                ],
                onset: "Acute onset following bilateral temporal lobe damage (trauma, surgery, herpes encephalitis, or neurodegeneration).",
                progression: "Full syndrome rare in humans (requires bilateral damage). Partial features more common. Recovery variable depending on etiology."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Visual Recognition", severity: .severe, description: "Visual agnosia: inability to recognize objects by sight despite intact vision."),
                    CognitiveDomain(domain: "Emotional Processing", severity: .severe, description: "Absent fear response, emotional blunting, inability to evaluate threat."),
                    CognitiveDomain(domain: "Memory", severity: .severe, description: "Severe amnesia (bilateral temporal lobe involvement damages hippocampi).")
                ],
                expectedTestPatterns: [
                    "Object recognition: Severely impaired visually (may identify by touch/sound)",
                    "Fear conditioning: Absent or markedly reduced",
                    "Memory testing: Severe anterograde amnesia",
                    "Behavioral observation reveals full syndrome"
                ],
                preservedFunctions: [
                    "Basic visual perception (can see objects, cannot recognize them)",
                    "Motor abilities",
                    "Language (may be intact if left temporal spared)",
                    "Object recognition by non-visual modalities"
                ],
                differentialConsiderations: [
                    "Herpes simplex encephalitis: common cause, fever and seizures preceding",
                    "Frontotemporal dementia: progressive behavioral changes but less visual agnosia",
                    "Pick disease: anterior temporal variant may produce partial features"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Bilateral anterior temporal lobe damage/atrophy",
                    "Bilateral amygdala damage",
                    "May show hippocampal damage",
                    "In HSV encephalitis: bilateral temporal FLAIR hyperintensity"
                ],
                ct: [
                    "Bilateral temporal lobe hypodensities or hemorrhagic changes",
                    "May show bilateral temporal atrophy"
                ],
                pet: [
                    "Bilateral anterior temporal hypometabolism"
                ],
                otherModalities: []
            ),
            relatedStructures: ["amygdala", "inferior-temporal-cortex", "fusiform-gyrus", "hippocampus"],
            epidemiology: "Full syndrome is rare in humans (bilateral temporal damage required). Partial features are more common with unilateral damage or neurodegeneration.",
            etiology: "Bilateral anterior temporal lobe destruction. Most commonly from herpes simplex encephalitis, traumatic brain injury, bilateral temporal lobectomy, or advanced frontotemporal/Alzheimer's dementia."
        ),

        Pathology(
            id: "locked-in-syndrome",
            name: "Locked-in Syndrome",
            category: .vascular,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Complete paralysis of all voluntary muscles except vertical eye movements",
                    "Preserved consciousness and cognition",
                    "Quadriplegia and anarthria",
                    "Can communicate through vertical eye movements and blinking",
                    "Preserved hearing and vision",
                    "Normal sleep-wake cycles and EEG"
                ],
                observableBehaviors: [
                    "Eyes open and tracking (demonstrates consciousness)",
                    "Responds to commands with eye movements or blinks",
                    "No voluntary limb or facial movement",
                    "No verbal output",
                    "May be initially misdiagnosed as coma or vegetative state",
                    "Emotional responses visible through eye movements (crying, widening)"
                ],
                onset: "Sudden onset, typically from basilar artery thrombosis or pontine hemorrhage.",
                progression: "Generally poor prognosis for motor recovery. Some patients develop limited distal limb movement. Cognitive function preserved."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Motor Output", severity: .severe, description: "Complete loss of motor output except vertical eye movements. Cognition is INTACT but cannot be expressed through normal channels."),
                    CognitiveDomain(domain: "Cognition Overall", severity: .minimal, description: "Cognitive abilities generally preserved. Depression and emotional distress common but understandable.")
                ],
                expectedTestPatterns: [
                    "Standard neuropsychological testing impossible due to motor limitations",
                    "Eye-tracking technology enables cognitive assessment",
                    "Preserved intelligence demonstrated through yes/no eye movement communication",
                    "EEG shows normal cortical activity (NOT coma pattern)",
                    "Evoked potentials: Normal cortical responses"
                ],
                preservedFunctions: [
                    "Consciousness and awareness",
                    "Cognition, memory, and language comprehension",
                    "Hearing and vision",
                    "Vertical eye movements",
                    "Sleep-wake cycles",
                    "Pain sensation"
                ],
                differentialConsiderations: [
                    "Coma: no awareness, no eye opening, abnormal EEG",
                    "Vegetative state: eyes open but no purposeful responses",
                    "Minimally conscious state: inconsistent purposeful behavior",
                    "Severe Guillain-Barre: peripheral cause, preserved brainstem reflexes"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Ventral pontine infarction (bilateral basis pontis)",
                    "Preserved tegmentum (reticular formation intact)",
                    "DWI: Restricted diffusion in ventral pons",
                    "MRA: Basilar artery occlusion"
                ],
                ct: [
                    "May show pontine hypodensity or hemorrhage",
                    "CT angiography: Basilar artery thrombosis"
                ],
                pet: [
                    "Preserved cortical metabolism (normal FDG-PET pattern)",
                    "Distinguishes from vegetative state (cortical hypometabolism)"
                ],
                otherModalities: [
                    ImagingFinding(modality: "EEG", findings: ["Normal alpha rhythm (unlike coma/vegetative state)", "Reactive to stimulation"])
                ]
            ),
            relatedStructures: ["brainstem-pons", "reticular-formation"],
            epidemiology: "Rare. Incidence estimated at <1 per million per year. Most cases from basilar artery stroke.",
            etiology: "Ventral pontine lesion (bilateral basis pontis destruction) disrupting all descending motor pathways while sparing the tegmentum (reticular formation). Most commonly basilar artery thrombosis."
        ),

        Pathology(
            id: "akinetic-mutism",
            name: "Akinetic Mutism",
            category: .syndromic,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Alert wakefulness without spontaneous movement or speech",
                    "Eyes open and may follow stimuli",
                    "Absent spontaneous verbal output",
                    "Absent spontaneous motor activity",
                    "May respond to very intense stimulation briefly",
                    "Sleep-wake cycle preserved"
                ],
                observableBehaviors: [
                    "Lies motionless with eyes open, appearing awake",
                    "Eyes may track moving objects or people",
                    "Does not speak, eat, or move spontaneously",
                    "May briefly respond to strong pain or loud commands",
                    "No emotional expression",
                    "Incontinence due to lack of initiation"
                ],
                onset: "Acute (bilateral anterior cerebral artery stroke, surgical damage) or subacute (tumor, hydrocephalus).",
                progression: "Variable. May improve partially with dopaminergic treatment. Depends on extent of cingulate damage and etiology."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Motivation/Drive", severity: .severe, description: "Complete absence of behavioral initiation. Abulia in its most extreme form."),
                    CognitiveDomain(domain: "Motor Initiation", severity: .severe, description: "Cannot initiate voluntary movement despite intact motor pathways."),
                    CognitiveDomain(domain: "Speech Initiation", severity: .severe, description: "Mutism — no spontaneous speech despite intact language networks.")
                ],
                expectedTestPatterns: [
                    "Standard testing impossible during acute phase",
                    "When recovering: responses are sparse, delayed, and brief",
                    "May show intact comprehension when motivation to respond returns",
                    "Cognitive abilities may be relatively preserved once initiation recovers"
                ],
                preservedFunctions: [
                    "Consciousness and wakefulness",
                    "Visual tracking",
                    "Language comprehension (likely preserved but cannot be demonstrated)",
                    "Motor pathways (intact but not utilized)",
                    "Sensory perception"
                ],
                differentialConsiderations: [
                    "Locked-in syndrome: preserved vertical eye movements, responds to commands",
                    "Coma: no wakefulness or eye opening",
                    "Catatonia (psychiatric): waxy flexibility, posturing, may respond to lorazepam",
                    "Severe depression: some preserved initiative, responds to treatment"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Bilateral anterior cingulate cortex lesions (most common cause)",
                    "Bilateral medial frontal lobe damage",
                    "May involve supplementary motor area bilaterally",
                    "Bilateral ACA territory infarction"
                ],
                ct: [
                    "Bilateral medial frontal hypodensities (if vascular)",
                    "May show hydrocephalus or third ventricular tumor"
                ],
                pet: [
                    "Severely reduced frontal and cingulate metabolism",
                    "Relative preservation of posterior cortical metabolism"
                ],
                otherModalities: []
            ),
            relatedStructures: ["cingulate-cortex", "supplementary-motor-area", "prefrontal-cortex"],
            epidemiology: "Rare. Most cases from bilateral anterior cerebral artery infarction or surgical complications.",
            etiology: "Bilateral anterior cingulate cortex destruction. Causes: bilateral ACA stroke, medial frontal tumors (butterfly glioma), anterior communicating artery aneurysm surgery, hydrocephalus."
        ),

        Pathology(
            id: "split-brain-syndrome",
            name: "Split-Brain Syndrome (Callosal Disconnection)",
            category: .syndromic,
            clinicalPresentation: ClinicalPresentation(
                signsAndSymptoms: [
                    "Inability to name objects presented to left visual field (right hemisphere)",
                    "Left hand unable to carry out verbally commanded actions",
                    "Alien hand phenomenon (left hand acts independently)",
                    "Inability to match stimuli across hemispheres",
                    "Double simultaneous drawing ability",
                    "In daily life, deficits often subtle due to compensatory strategies"
                ],
                observableBehaviors: [
                    "Cannot verbally identify objects placed in left hand (eyes closed)",
                    "Left hand may act contrary to right hand's intentions",
                    "Difficulty with bimanual coordination on novel tasks",
                    "May pick correct object with left hand but cannot name it",
                    "Compensatory head/eye movements to share information across hemifields",
                    "Social comportment and personality generally preserved"
                ],
                onset: "After corpus callosotomy (surgical treatment for intractable epilepsy) or extensive callosal lesion.",
                progression: "Deficits most apparent acutely. Patients develop compensatory strategies over months. Subtle deficits persist on formal testing."
            ),
            neuropsychProfile: NeuropsychProfile(
                cognitiveDomainsAffected: [
                    CognitiveDomain(domain: "Interhemispheric Transfer", severity: .severe, description: "Cannot transfer sensory, motor, or cognitive information between hemispheres."),
                    CognitiveDomain(domain: "Bimanual Coordination", severity: .moderate, description: "Difficulty coordinating both hands on novel tasks. Left hand may interfere with right."),
                    CognitiveDomain(domain: "Naming (Left Field)", severity: .severe, description: "Cannot verbally identify stimuli presented exclusively to right hemisphere.")
                ],
                expectedTestPatterns: [
                    "Tachistoscopic testing: Cannot name left visual field stimuli, can match with left hand",
                    "Dichotic listening: Left ear (right hemisphere) stimuli cannot be verbally reported",
                    "Bimanual tasks: Impaired coordination, especially novel tasks",
                    "Left hand: Cannot write or carry out verbal commands (left hand apraxia)",
                    "Right hemisphere: Superior spatial processing, cannot express verbally",
                    "General IQ scores usually preserved"
                ],
                preservedFunctions: [
                    "Each hemisphere functions independently within its domain",
                    "Language (left hemisphere)",
                    "Spatial processing (right hemisphere)",
                    "Overall IQ typically preserved",
                    "Memory, attention, executive function (each hemisphere independently)",
                    "Daily functioning with compensatory strategies"
                ],
                differentialConsiderations: [
                    "Alien hand from SMA lesion: unilateral, without interhemispheric transfer deficit",
                    "Callosal tumors: progressive symptoms, may have additional findings",
                    "Multiple sclerosis: callosal plaques may cause partial disconnection",
                    "Agenesis of corpus callosum: developmental compensation, milder presentation"
                ]
            ),
            neuroimaging: NeuroimagingFindings(
                mri: [
                    "Complete or partial absence of corpus callosum (post-callosotomy)",
                    "DTI: Absence of callosal fibers crossing midline",
                    "In callosal tumors or MS: T2/FLAIR hyperintensity within corpus callosum"
                ],
                ct: [
                    "Absent corpus callosum if complete callosotomy",
                    "May show callosal lesion or tumor"
                ],
                pet: [
                    "Functional asymmetries may be demonstrated during lateralized tasks",
                    "Each hemisphere shows independent metabolic activity patterns"
                ],
                otherModalities: [
                    ImagingFinding(modality: "DTI/Tractography", findings: ["Absent or reduced callosal fibers", "Preserved intrahemispheric connections"])
                ]
            ),
            relatedStructures: ["corpus-callosum", "prefrontal-cortex", "primary-motor-cortex", "primary-visual-cortex"],
            epidemiology: "Rare. Primarily seen after surgical callosotomy for intractable epilepsy (rarely performed now due to VNS and responsive neurostimulation).",
            etiology: "Surgical section of corpus callosum (callosotomy). Also from callosal infarction (ACA territory), tumor infiltration, or demyelination."
        )
    ]

    // MARK: - Lookup Methods

    static func pathology(byID id: String) -> Pathology? {
        all.first { $0.id == id }
    }

    static func pathologies(forCategory category: PathologyCategory) -> [Pathology] {
        all.filter { $0.category == category }
    }

    static func pathologies(forStructure structureID: String) -> [Pathology] {
        all.filter { $0.relatedStructures.contains(structureID) }
    }

    static func search(_ query: String) -> [Pathology] {
        let lowered = query.lowercased()
        return all.filter { pathology in
            pathology.name.lowercased().contains(lowered) ||
            pathology.clinicalPresentation.signsAndSymptoms.contains { $0.lowercased().contains(lowered) } ||
            pathology.neuropsychProfile.cognitiveDomainsAffected.contains { $0.domain.lowercased().contains(lowered) } ||
            pathology.category.rawValue.lowercased().contains(lowered)
        }
    }
}
