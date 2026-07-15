import Foundation

struct BrainStructureStore {
    static let all: [BrainStructure] = [
        // MARK: - Frontal Lobe (7)
        BrainStructure(
            id: "prefrontal-cortex",
            name: "Prefrontal Cortex",
            region: .frontalLobe,
            aliases: ["PFC", "Anterior Frontal Cortex"],
            description: "The prefrontal cortex occupies the anterior portion of the frontal lobes and is critical for higher-order cognitive functions. It is the last cortical region to fully myelinate, not reaching maturity until the mid-20s.",
            functions: ["Executive function and planning", "Working memory", "Decision-making and judgment", "Personality expression", "Social behavior regulation", "Impulse control"],
            clinicalSignificance: "Damage produces disinhibition, poor planning, personality changes, and impaired social judgment. The famous case of Phineas Gage demonstrated frontal lobe syndrome after iron rod penetrated his PFC.",
            associatedDisorders: ["ADHD", "Schizophrenia", "Frontotemporal Dementia", "Antisocial Personality Disorder"],
            connections: ["orbitofrontal-cortex", "cingulate-cortex", "thalamus", "basal-ganglia-caudate"],
            brodmannAreas: [9, 10, 11, 12, 46, 47],
            lateralization: .bilateral,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "primary-motor-cortex",
            name: "Primary Motor Cortex",
            region: .frontalLobe,
            aliases: ["M1", "Precentral Gyrus", "BA4"],
            description: "The primary motor cortex lies along the precentral gyrus and contains a somatotopic motor map (motor homunculus) that controls voluntary movements of the contralateral body.",
            functions: ["Voluntary movement execution", "Somatotopic motor representation", "Fine motor control", "Force modulation"],
            clinicalSignificance: "Lesions cause contralateral paresis or paralysis. Upper motor neuron signs include spasticity, hyperreflexia, and Babinski sign. Most commonly affected in middle cerebral artery stroke.",
            associatedDisorders: ["Stroke", "ALS (Upper Motor Neuron)", "Brain Tumors"],
            connections: ["premotor-cortex", "supplementary-motor-area", "primary-somatosensory-cortex", "cerebellum", "basal-ganglia-putamen"],
            brodmannAreas: [4],
            lateralization: .bilateral,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "premotor-cortex",
            name: "Premotor Cortex",
            region: .frontalLobe,
            aliases: ["PMC", "BA6 lateral"],
            description: "The premotor cortex lies anterior to the primary motor cortex and is involved in planning and programming movements before execution. It integrates sensory information to guide motor actions.",
            functions: ["Motor planning and preparation", "Movement sequencing", "Sensory-guided movement", "Motor learning", "Mirror neuron activity"],
            clinicalSignificance: "Lesions produce limb-kinetic apraxia — loss of precise, finely graded movement execution despite intact strength and sensation. Left premotor involvement may contribute to ideomotor apraxia through disruption of frontal-parietal praxis networks. Impaired motor programming and sequencing.",
            associatedDisorders: ["Apraxia", "Motor Planning Deficits"],
            connections: ["primary-motor-cortex", "supplementary-motor-area", "parietal-superior", "cerebellum"],
            brodmannAreas: [6],
            lateralization: .bilateral,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "supplementary-motor-area",
            name: "Supplementary Motor Area",
            region: .frontalLobe,
            aliases: ["SMA", "BA6 medial"],
            description: "The SMA lies on the medial surface of the frontal lobe, anterior to the primary motor cortex. It is critical for internally generated movement sequences and bimanual coordination.",
            functions: ["Internally generated movement", "Bimanual coordination", "Motor sequence planning", "Speech initiation"],
            clinicalSignificance: "Lesions can cause alien hand syndrome (contralateral hand acts independently) and difficulty initiating voluntary movements. Transient mutism may occur with left SMA lesions.",
            associatedDisorders: ["Alien Hand Syndrome", "Motor Initiation Deficits"],
            connections: ["primary-motor-cortex", "premotor-cortex", "cingulate-cortex", "basal-ganglia-caudate"],
            brodmannAreas: [6],
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "brocas-area",
            name: "Broca's Area",
            region: .frontalLobe,
            aliases: ["BA44/45", "Inferior Frontal Gyrus (pars opercularis & triangularis)"],
            description: "Broca's area in the left inferior frontal gyrus is the primary cortical region for speech production and language output. Discovered by Paul Broca in 1861 through the patient 'Tan'.",
            functions: ["Speech production", "Language output programming", "Syntactic processing", "Verbal working memory", "Action understanding"],
            clinicalSignificance: "Damage causes Broca's aphasia: non-fluent, effortful, telegraphic speech with relatively preserved comprehension. Patients are typically aware of their deficit, leading to frustration.",
            associatedDisorders: ["Broca's Aphasia", "Speech Apraxia", "Agrammatism"],
            connections: ["wernickes-area", "primary-motor-cortex", "prefrontal-cortex", "supplementary-motor-area"],
            brodmannAreas: [44, 45],
            lateralization: .leftDominant,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "frontal-eye-fields",
            name: "Frontal Eye Fields",
            region: .frontalLobe,
            aliases: ["FEF", "BA8"],
            description: "The frontal eye fields control voluntary saccadic eye movements and visual attention shifts. They work in concert with the superior colliculus for eye movement control.",
            functions: ["Voluntary saccadic eye movements", "Visual attention direction", "Anti-saccade generation", "Visual search coordination"],
            clinicalSignificance: "Acute lesions cause eyes to deviate toward the side of the lesion (away from the contralateral visual field). Patients cannot voluntarily direct gaze contralaterally.",
            associatedDisorders: ["Gaze Deviation", "Oculomotor Apraxia"],
            connections: ["prefrontal-cortex", "parietal-superior", "primary-visual-cortex"],
            brodmannAreas: [8],
            lateralization: .bilateral,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "orbitofrontal-cortex",
            name: "Orbitofrontal Cortex",
            region: .frontalLobe,
            aliases: ["OFC", "Ventromedial PFC"],
            description: "The orbitofrontal cortex sits above the orbits of the eyes on the ventral surface of the frontal lobes. It plays a key role in emotional regulation, reward processing, and social decision-making.",
            functions: ["Emotional regulation", "Reward and punishment processing", "Social behavior and empathy", "Impulse control", "Olfactory processing"],
            clinicalSignificance: "Damage produces personality changes including impulsivity, poor social judgment, emotional lability, and inappropriate behavior. Patients may show 'acquired sociopathy' with intact intellect.",
            associatedDisorders: ["Disinhibition Syndrome", "Acquired Sociopathy", "Behavioral Variant FTD"],
            connections: ["prefrontal-cortex", "amygdala", "cingulate-cortex", "thalamus"],
            brodmannAreas: [11, 12, 47],
            lateralization: .bilateral,
            diagramView: .medial
        ),

        BrainStructure(
            id: "superior-frontal-gyrus",
            name: "Superior Frontal Gyrus",
            region: .frontalLobe,
            aliases: ["SFG", "BA8/9"],
            description: "The superior frontal gyrus occupies the superior portion of the frontal lobe, extending from the frontal pole to the precentral sulcus. It is involved in self-awareness, working memory, and executive function.",
            functions: ["Self-awareness and introspection", "Working memory maintenance", "Executive function", "Voluntary action initiation", "Cognitive control"],
            clinicalSignificance: "Lesions can impair working memory and executive function. The medial portion overlaps with supplementary motor area function. Atrophy is observed in behavioral variant frontotemporal dementia.",
            associatedDisorders: ["Frontotemporal Dementia", "ADHD", "Depression"],
            connections: ["prefrontal-cortex", "supplementary-motor-area", "cingulate-cortex", "middle-frontal-gyrus"],
            brodmannAreas: [8, 9],
            lateralization: .bilateral,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "middle-frontal-gyrus",
            name: "Middle Frontal Gyrus",
            region: .frontalLobe,
            aliases: ["MFG", "BA9/46", "Dorsolateral PFC"],
            description: "The middle frontal gyrus lies between the superior and inferior frontal sulci. It encompasses the dorsolateral prefrontal cortex (DLPFC), critical for working memory and cognitive flexibility.",
            functions: ["Working memory", "Cognitive flexibility", "Attention control", "Response inhibition", "Task switching"],
            clinicalSignificance: "The DLPFC region is a primary target for TMS treatment in depression. Damage impairs working memory, set-shifting, and attention. Dysfunction is implicated in schizophrenia and ADHD.",
            associatedDisorders: ["Major Depression", "Schizophrenia", "ADHD"],
            connections: ["prefrontal-cortex", "superior-frontal-gyrus", "parietal-inferior", "thalamus"],
            brodmannAreas: [9, 46],
            lateralization: .bilateral,
            diagramView: .lateral
        ),

        // MARK: - Parietal Lobe (4)
        BrainStructure(
            id: "primary-somatosensory-cortex",
            name: "Primary Somatosensory Cortex",
            region: .parietalLobe,
            aliases: ["S1", "Postcentral Gyrus", "BA1-3"],
            description: "The primary somatosensory cortex lies along the postcentral gyrus, immediately posterior to the central sulcus. It contains a somatotopic sensory map (sensory homunculus) for tactile processing.",
            functions: ["Tactile perception", "Proprioception", "Temperature sensing", "Pain localization", "Somatotopic sensory mapping"],
            clinicalSignificance: "Lesions produce contralateral sensory loss, impaired two-point discrimination, and astereognosis (inability to identify objects by touch). Cortical sensory loss differs from peripheral in that it affects discriminative but not crude touch.",
            associatedDisorders: ["Cortical Sensory Loss", "Astereognosis", "Tactile Agnosia"],
            connections: ["primary-motor-cortex", "parietal-superior", "parietal-inferior", "thalamus"],
            brodmannAreas: [1, 2, 3],
            lateralization: .bilateral,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "parietal-superior",
            name: "Superior Parietal Lobule",
            region: .parietalLobe,
            aliases: ["SPL", "BA5/7"],
            description: "The superior parietal lobule integrates visual and somatosensory information for spatial awareness and visually guided reaching. It is part of the dorsal 'where/how' visual stream.",
            functions: ["Visuospatial processing", "Spatial attention", "Visually guided reaching", "Body schema representation", "Mental rotation"],
            clinicalSignificance: "Bilateral lesions cause Balint syndrome: simultanagnosia (inability to perceive multiple objects), optic ataxia (impaired visually guided reaching), and oculomotor apraxia. Unilateral lesions cause contralateral neglect.",
            associatedDisorders: ["Balint Syndrome", "Optic Ataxia", "Hemispatial Neglect"],
            connections: ["primary-somatosensory-cortex", "visual-association", "premotor-cortex", "frontal-eye-fields"],
            brodmannAreas: [5, 7],
            lateralization: .bilateral,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "parietal-inferior",
            name: "Inferior Parietal Lobule",
            region: .parietalLobe,
            aliases: ["IPL", "Supramarginal Gyrus (BA40)"],
            description: "The inferior parietal lobule is a multimodal association area at the junction of visual, auditory, and somatosensory cortices. It integrates information across modalities for higher cognitive functions.",
            functions: ["Multimodal sensory integration", "Mathematical calculation", "Reading and writing", "Tool use understanding", "Phonological processing"],
            clinicalSignificance: "Left hemisphere lesions produce Gerstmann syndrome: agraphia (impaired writing), acalculia (impaired calculation), finger agnosia, and left-right confusion. Right lesions contribute to hemispatial neglect.",
            associatedDisorders: ["Gerstmann Syndrome", "Acalculia", "Hemispatial Neglect", "Ideational Apraxia"],
            connections: ["primary-somatosensory-cortex", "angular-gyrus", "wernickes-area", "premotor-cortex"],
            brodmannAreas: [40],
            lateralization: .bilateral,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "angular-gyrus",
            name: "Angular Gyrus",
            region: .parietalLobe,
            aliases: ["BA39", "Inferior Parietal (posterior)"],
            description: "The angular gyrus sits at the junction of temporal, parietal, and occipital lobes. It is critical for semantic processing, reading comprehension, and cross-modal integration.",
            functions: ["Semantic processing", "Reading comprehension", "Arithmetic", "Spatial cognition", "Attention and memory retrieval"],
            clinicalSignificance: "Left angular gyrus lesions cause alexia with agraphia (inability to read or write), anomia (word-finding difficulty), and spatial disorientation. Part of Geschwind's territory for language.",
            associatedDisorders: ["Alexia with Agraphia", "Anomic Aphasia", "Semantic Processing Deficits"],
            connections: ["wernickes-area", "parietal-inferior", "visual-association", "prefrontal-cortex"],
            brodmannAreas: [39],
            lateralization: .leftDominant,
            diagramView: .lateral
        ),

        BrainStructure(
            id: "supramarginal-gyrus",
            name: "Supramarginal Gyrus",
            region: .parietalLobe,
            aliases: ["SMG", "BA40", "Anterior IPL"],
            description: "The supramarginal gyrus wraps around the posterior end of the lateral sulcus in the inferior parietal lobule. It is critical for phonological processing, tactile perception, and empathy.",
            functions: ["Phonological processing", "Tactile discrimination", "Empathy and perspective-taking", "Language articulation planning", "Spatial attention"],
            clinicalSignificance: "Left supramarginal lesions cause conduction aphasia (impaired repetition with preserved comprehension and fluency). Also implicated in ideomotor apraxia and phonological dyslexia.",
            associatedDisorders: ["Conduction Aphasia", "Ideomotor Apraxia", "Phonological Dyslexia"],
            connections: ["parietal-inferior", "wernickes-area", "brocas-area", "primary-somatosensory-cortex"],
            brodmannAreas: [40],
            lateralization: .leftDominant,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "precuneus",
            name: "Precuneus",
            region: .parietalLobe,
            aliases: ["Medial Parietal Cortex", "BA7m"],
            description: "The precuneus is a prominent structure on the medial surface of the parietal lobe, between the marginal ramus and parieto-occipital sulcus. It is one of the most metabolically active brain regions at rest.",
            functions: ["Self-referential processing", "Episodic memory retrieval", "Visuospatial imagery", "Consciousness and awareness", "Default mode network hub"],
            clinicalSignificance: "One of the earliest regions affected in Alzheimer's disease, showing hypometabolism on PET scans before clinical symptoms. Key node of the default mode network. Reduced activity correlates with loss of consciousness.",
            associatedDisorders: ["Alzheimer's Disease", "Disorders of Consciousness", "Depression"],
            connections: ["cingulate-cortex", "parietal-superior", "prefrontal-cortex", "hippocampus"],
            brodmannAreas: [7],
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "paracentral-lobule",
            name: "Paracentral Lobule",
            region: .parietalLobe,
            aliases: ["PCL"],
            description: "The paracentral lobule straddles the medial surface of the frontal and parietal lobes around the central sulcus. It contains the medial extensions of the primary motor and somatosensory cortices representing the lower limb.",
            functions: ["Lower limb motor control", "Lower limb sensory processing", "Bladder and bowel control", "Foot and leg representation"],
            clinicalSignificance: "Lesions (e.g., from anterior cerebral artery stroke) cause contralateral lower limb weakness and sensory loss. Bilateral damage can cause urinary incontinence due to loss of voluntary bladder control.",
            associatedDisorders: ["ACA Stroke Syndrome", "Lower Limb Paralysis", "Urinary Incontinence"],
            connections: ["primary-motor-cortex", "primary-somatosensory-cortex", "supplementary-motor-area", "cingulate-cortex"],
            brodmannAreas: [4, 1, 2, 3],
            lateralization: .bilateral,
            diagramView: .medial
        ),

        // MARK: - Temporal Lobe (5)
        BrainStructure(
            id: "primary-auditory-cortex",
            name: "Primary Auditory Cortex",
            region: .temporalLobe,
            aliases: ["A1", "Heschl's Gyrus", "BA41/42"],
            description: "The primary auditory cortex lies within the lateral sulcus on the superior temporal gyrus (Heschl's gyrus). It performs tonotopic processing of auditory information from both ears.",
            functions: ["Tonotopic auditory processing", "Sound frequency analysis", "Auditory pattern recognition", "Temporal resolution of sounds"],
            clinicalSignificance: "Bilateral lesions cause cortical deafness (rare). Unilateral lesions produce subtle auditory processing deficits, particularly in sound localization and pattern discrimination contralaterally.",
            associatedDisorders: ["Cortical Deafness", "Auditory Processing Disorder"],
            connections: ["wernickes-area", "parietal-inferior", "prefrontal-cortex", "thalamus"],
            brodmannAreas: [41, 42],
            lateralization: .bilateral,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "wernickes-area",
            name: "Wernicke's Area",
            region: .temporalLobe,
            aliases: ["BA22", "Posterior Superior Temporal Gyrus"],
            description: "Wernicke's area in the posterior superior temporal gyrus of the dominant hemisphere is essential for language comprehension. Identified by Carl Wernicke in 1874.",
            functions: ["Language comprehension", "Phonological processing", "Auditory word recognition", "Semantic access"],
            clinicalSignificance: "Damage causes Wernicke's aphasia: fluent but meaningless speech (word salad), severely impaired comprehension, paraphasias (word substitutions), and poor repetition. Patients are often unaware of their deficit (anosognosia).",
            associatedDisorders: ["Wernicke's Aphasia", "Conduction Aphasia (arcuate fasciculus)", "Transcortical Sensory Aphasia"],
            connections: ["brocas-area", "angular-gyrus", "primary-auditory-cortex", "parietal-inferior"],
            brodmannAreas: [22],
            lateralization: .leftDominant,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "fusiform-gyrus",
            name: "Fusiform Gyrus",
            region: .temporalLobe,
            aliases: ["Fusiform Face Area", "BA37", "Visual Word Form Area"],
            description: "The fusiform gyrus on the ventral temporal surface contains the fusiform face area (FFA) specialized for face recognition and the visual word form area (VWFA) for reading.",
            functions: ["Face recognition", "Visual word form recognition", "Object categorization", "Color perception of objects"],
            clinicalSignificance: "Prosopagnosia (face blindness) — inability to recognize familiar faces despite intact vision — most commonly results from bilateral occipitotemporal damage, though the right fusiform gyrus is dominant for face processing; extensive unilateral right fusiform damage can produce significant impairment. Left fusiform damage can cause pure alexia (inability to read with preserved writing).",
            associatedDisorders: ["Prosopagnosia", "Pure Alexia", "Visual Object Agnosia"],
            connections: ["primary-visual-cortex", "visual-association", "hippocampus", "amygdala"],
            brodmannAreas: [37],
            lateralization: .rightDominant,
            diagramView: .medial
        ),
        BrainStructure(
            id: "superior-temporal-sulcus",
            name: "Superior Temporal Sulcus",
            region: .temporalLobe,
            aliases: ["STS"],
            description: "The superior temporal sulcus is a multisensory integration area involved in social cognition, biological motion perception, and theory of mind. It responds to faces, voices, and social cues.",
            functions: ["Social cognition", "Biological motion perception", "Audiovisual integration", "Theory of mind", "Gaze direction processing"],
            clinicalSignificance: "Dysfunction is associated with deficits in social perception and theory of mind. Reduced activation in the STS is one of the most replicated neuroimaging findings in autism spectrum disorder.",
            associatedDisorders: ["Autism Spectrum Disorder", "Social Cognition Deficits"],
            connections: ["fusiform-gyrus", "amygdala", "prefrontal-cortex", "parietal-inferior"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "inferior-temporal-cortex",
            name: "Inferior Temporal Cortex",
            region: .temporalLobe,
            aliases: ["IT", "BA20/21", "Ventral Visual Stream"],
            description: "The inferior temporal cortex is the endpoint of the ventral 'what' visual stream, responsible for complex object recognition and visual categorization. It builds increasingly abstract representations of visual stimuli.",
            functions: ["Object recognition", "Visual categorization", "Semantic knowledge storage", "Complex form perception"],
            clinicalSignificance: "Bilateral lesions cause visual agnosia — inability to recognize objects by sight despite intact vision. Anterior temporal damage contributes to semantic dementia with progressive loss of conceptual knowledge.",
            associatedDisorders: ["Visual Agnosia", "Semantic Dementia", "Temporal Lobe Epilepsy"],
            connections: ["visual-association", "fusiform-gyrus", "hippocampus", "prefrontal-cortex"],
            brodmannAreas: [20, 21],
            lateralization: .bilateral,
            diagramView: .lateral
        ),

        BrainStructure(
            id: "middle-temporal-gyrus",
            name: "Middle Temporal Gyrus",
            region: .temporalLobe,
            aliases: ["MTG", "BA21"],
            description: "The middle temporal gyrus lies between the superior and inferior temporal sulci on the lateral temporal surface. It plays a role in semantic processing, language comprehension, and multimodal sensory integration.",
            functions: ["Semantic processing", "Language comprehension", "Reading and lexical access", "Audiovisual integration", "Face and object recognition support"],
            clinicalSignificance: "Left MTG lesions contribute to transcortical sensory aphasia and semantic processing deficits. The region is frequently involved in temporal lobe epilepsy. Abnormal activation patterns observed in dyslexia.",
            associatedDisorders: ["Transcortical Sensory Aphasia", "Temporal Lobe Epilepsy", "Dyslexia"],
            connections: ["wernickes-area", "angular-gyrus", "inferior-temporal-cortex", "prefrontal-cortex"],
            brodmannAreas: [21],
            lateralization: .leftDominant,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "entorhinal-cortex",
            name: "Entorhinal Cortex",
            region: .temporalLobe,
            aliases: ["EC", "BA28/34"],
            description: "The entorhinal cortex lies in the medial temporal lobe, anterior to the hippocampus. It serves as the major gateway for information entering and leaving the hippocampus and contains grid cells for spatial navigation.",
            functions: ["Gateway to hippocampal memory system", "Spatial navigation (grid cells)", "Memory encoding interface", "Olfactory processing", "Temporal context encoding"],
            clinicalSignificance: "The entorhinal cortex is the earliest cortical region to develop neurofibrillary tangles in Alzheimer's disease, even before the hippocampus. Volume loss here is an early biomarker for AD progression.",
            associatedDisorders: ["Alzheimer's Disease (earliest site)", "Temporal Lobe Epilepsy", "Spatial Navigation Deficits"],
            connections: ["hippocampus", "amygdala", "parahippocampal-gyrus", "prefrontal-cortex"],
            brodmannAreas: [28, 34],
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "parahippocampal-gyrus",
            name: "Parahippocampal Gyrus",
            region: .temporalLobe,
            aliases: ["PHG", "Parahippocampal Place Area"],
            description: "The parahippocampal gyrus lies on the ventromedial surface of the temporal lobe, surrounding the hippocampus. It contains the parahippocampal place area (PPA) specialized for scene and place recognition.",
            functions: ["Scene and place recognition (PPA)", "Contextual memory encoding", "Spatial navigation support", "Visuospatial processing", "Episodic memory formation"],
            clinicalSignificance: "Lesions impair topographical memory and the ability to recognize familiar scenes and places. The PPA is critical for navigation; damage causes topographical disorientation. Activated during spatial memory tasks.",
            associatedDisorders: ["Topographical Disorientation", "Topographical Amnesia", "Alzheimer's Disease"],
            connections: ["hippocampus", "entorhinal-cortex", "fusiform-gyrus", "cingulate-cortex"],
            brodmannAreas: [27, 28, 35, 36],
            lateralization: .bilateral,
            diagramView: .medial
        ),

        // MARK: - Occipital Lobe (3)
        BrainStructure(
            id: "primary-visual-cortex",
            name: "Primary Visual Cortex",
            region: .occipitalLobe,
            aliases: ["V1", "Striate Cortex", "BA17", "Calcarine Cortex"],
            description: "The primary visual cortex surrounds the calcarine sulcus on the medial occipital surface. It performs retinotopic processing of visual input, detecting edges, orientations, and basic visual features.",
            functions: ["Retinotopic visual processing", "Edge and orientation detection", "Simple feature extraction", "Binocular disparity processing"],
            clinicalSignificance: "Bilateral destruction causes cortical blindness. Unilateral lesions produce contralateral homonymous hemianopia. Anton syndrome: cortical blindness with denial of visual loss (anosognosia).",
            associatedDisorders: ["Cortical Blindness", "Homonymous Hemianopia", "Anton Syndrome", "Visual Scotomas"],
            connections: ["visual-association", "thalamus", "parietal-superior"],
            brodmannAreas: [17],
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "visual-association",
            name: "Visual Association Areas",
            region: .occipitalLobe,
            aliases: ["V2-V5", "Extrastriate Cortex", "BA18/19"],
            description: "The visual association areas surround V1 and perform increasingly complex visual processing. V4 processes color, V5/MT processes motion, and V2 processes contours and texture.",
            functions: ["Motion perception (V5/MT)", "Color processing (V4)", "Form and contour analysis (V2)", "Depth perception", "Visual attention modulation"],
            clinicalSignificance: "V5/MT lesions cause akinetopsia (motion blindness) — inability to perceive movement, seeing the world in static frames. V4 lesions cause achromatopsia (cortical color blindness).",
            associatedDisorders: ["Akinetopsia", "Achromatopsia", "Visual Form Agnosia"],
            connections: ["primary-visual-cortex", "fusiform-gyrus", "parietal-superior", "inferior-temporal-cortex"],
            brodmannAreas: [18, 19],
            lateralization: .bilateral,
            diagramView: .lateral
        ),
        BrainStructure(
            id: "cuneus-lingual",
            name: "Cuneus & Lingual Gyrus",
            region: .occipitalLobe,
            aliases: ["Medial Occipital Cortex"],
            description: "The cuneus (superior to calcarine sulcus) and lingual gyrus (inferior) process the lower and upper contralateral visual fields respectively. They are part of the early visual processing pathway.",
            functions: ["Upper visual field processing (lingual)", "Lower visual field processing (cuneus)", "Visual memory encoding", "Color processing"],
            clinicalSignificance: "Lesions produce contralateral quadrantanopia. Cuneus lesions affect the lower visual field quadrant; lingual gyrus lesions affect the upper quadrant. Bilateral damage contributes to cortical blindness.",
            associatedDisorders: ["Quadrantanopia", "Visual Field Deficits"],
            connections: ["primary-visual-cortex", "visual-association", "hippocampus"],
            brodmannAreas: [17, 18, 19],
            lateralization: .bilateral,
            diagramView: .medial
        ),

        // MARK: - Limbic System (5)
        BrainStructure(
            id: "hippocampus",
            name: "Hippocampus",
            region: .limbicSystem,
            aliases: ["Hippocampal Formation", "Cornu Ammonis"],
            description: "The hippocampus is a seahorse-shaped structure in the medial temporal lobe, essential for converting short-term memories into long-term declarative memories. The famous patient H.M. (Henry Molaison) demonstrated its critical role after bilateral hippocampal removal.",
            functions: ["Episodic memory encoding", "Spatial navigation and cognitive maps", "Memory consolidation", "Contextual memory", "Pattern separation and completion"],
            clinicalSignificance: "Bilateral damage causes profound anterograde amnesia — inability to form new declarative memories, as demonstrated by patient H.M. The hippocampus is the earliest and most severely affected structure in Alzheimer's disease.",
            associatedDisorders: ["Alzheimer's Disease", "Amnesia", "Temporal Lobe Epilepsy", "PTSD"],
            connections: ["amygdala", "fornix", "mammillary-bodies", "cingulate-cortex", "prefrontal-cortex"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "amygdala",
            name: "Amygdala",
            region: .limbicSystem,
            aliases: ["Amygdaloid Complex", "Amygdaloid Body"],
            description: "The amygdala is an almond-shaped nucleus in the anterior medial temporal lobe. It is the brain's threat detection system, critical for fear conditioning, emotional memory, and social evaluation.",
            functions: ["Fear conditioning and detection", "Emotional memory formation", "Threat assessment", "Social evaluation (trustworthiness)", "Emotional modulation of attention"],
            clinicalSignificance: "Bilateral damage causes Kluver-Bucy syndrome: absence of fear, hyperorality, visual agnosia, and hypersexuality. Urbach-Wiethe disease (bilateral calcification) produces selective inability to recognize fearful facial expressions.",
            associatedDisorders: ["Anxiety Disorders", "PTSD", "Phobias", "Kluver-Bucy Syndrome", "Urbach-Wiethe Disease"],
            connections: ["hippocampus", "prefrontal-cortex", "orbitofrontal-cortex", "cingulate-cortex", "hypothalamus"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "cingulate-cortex",
            name: "Cingulate Cortex",
            region: .limbicSystem,
            aliases: ["Cingulate Gyrus", "BA24/32 (anterior)", "BA23/31 (posterior)"],
            description: "The cingulate cortex wraps around the corpus callosum on the medial surface. The anterior cingulate monitors errors and conflicts; the posterior cingulate is involved in self-referential processing and memory.",
            functions: ["Error monitoring and conflict detection", "Emotional regulation", "Pain processing (affective component)", "Motivation and reward", "Self-referential thought (posterior)"],
            clinicalSignificance: "Bilateral anterior cingulate lesions can cause akinetic mutism — a state of alert wakefulness without spontaneous movement or speech. Also associated with apathy, reduced motivation, and emotional blunting.",
            associatedDisorders: ["Akinetic Mutism", "OCD", "Depression", "Apathy Syndrome"],
            connections: ["prefrontal-cortex", "amygdala", "hippocampus", "orbitofrontal-cortex", "supplementary-motor-area"],
            brodmannAreas: [24, 32, 23, 31],
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "fornix",
            name: "Fornix",
            region: .limbicSystem,
            aliases: ["Fimbria-Fornix"],
            description: "The fornix is a C-shaped white matter bundle that serves as the major output pathway of the hippocampus, connecting it to the mammillary bodies and septal nuclei as part of the Papez circuit.",
            functions: ["Hippocampal output pathway", "Memory circuit relay (Papez circuit)", "Connects hippocampus to diencephalon", "Episodic memory transmission"],
            clinicalSignificance: "Transection of the fornix (e.g., by tumor or surgery) can cause anterograde amnesia similar to hippocampal damage, confirming its critical role in the memory circuit.",
            associatedDisorders: ["Anterograde Amnesia", "Fornix Lesion Syndrome"],
            connections: ["hippocampus", "mammillary-bodies", "thalamus", "cingulate-cortex"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "mammillary-bodies",
            name: "Mammillary Bodies",
            region: .limbicSystem,
            aliases: ["Corpora Mammillaria"],
            description: "The mammillary bodies are paired nuclei at the base of the brain, posterior to the hypothalamus. They are a relay station in the Papez memory circuit, receiving input from the hippocampus via the fornix.",
            functions: ["Papez circuit relay station", "Memory consolidation", "Spatial memory processing", "Head direction signaling"],
            clinicalSignificance: "Degeneration due to thiamine (B1) deficiency in chronic alcoholism causes Korsakoff syndrome: severe anterograde amnesia, confabulation (fabricating memories), and retrograde amnesia.",
            associatedDisorders: ["Korsakoff Syndrome", "Wernicke-Korsakoff Syndrome", "Thiamine Deficiency"],
            connections: ["fornix", "thalamus", "hippocampus", "cingulate-cortex"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),

        BrainStructure(
            id: "nucleus-accumbens",
            name: "Nucleus Accumbens",
            region: .limbicSystem,
            aliases: ["NAc", "Ventral Striatum"],
            description: "The nucleus accumbens is a small nucleus in the ventral striatum at the junction of the caudate and putamen. It is the brain's primary reward center, mediating pleasure, motivation, and reinforcement learning.",
            functions: ["Reward processing", "Motivation and drive", "Reinforcement learning", "Pleasure and euphoria", "Addiction circuitry"],
            clinicalSignificance: "Central to the neurobiology of addiction: drugs of abuse increase dopamine release in the NAc. Deep brain stimulation of the NAc is being investigated for treatment-resistant depression and OCD.",
            associatedDisorders: ["Substance Use Disorders", "Addiction", "Anhedonia", "Depression", "OCD"],
            connections: ["prefrontal-cortex", "amygdala", "hippocampus", "basal-ganglia-putamen"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "septal-nuclei",
            name: "Septal Nuclei",
            region: .limbicSystem,
            aliases: ["Septal Area", "Septal Region"],
            description: "The septal nuclei are a group of subcortical structures located anterior to the anterior commissure in the medial wall of the hemisphere. They are part of the limbic system's reward and pleasure circuitry.",
            functions: ["Reward and pleasure", "Limbic system modulation", "Cholinergic input to hippocampus", "Emotional regulation", "Autonomic control"],
            clinicalSignificance: "Historically called the 'pleasure center' based on Olds and Milner's intracranial self-stimulation experiments. Lesions can cause rage reactions (septal rage). Provides major cholinergic input to hippocampus via medial septal nucleus.",
            associatedDisorders: ["Septal Rage Syndrome", "Memory Deficits (cholinergic)"],
            connections: ["hippocampus", "amygdala", "hypothalamus", "fornix", "cingulate-cortex"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "insula",
            name: "Insula",
            region: .limbicSystem,
            aliases: ["Insular Cortex", "Island of Reil", "BA13-16"],
            description: "The insula is a cortical region hidden deep within the lateral sulcus, beneath the frontal, parietal, and temporal opercula. It integrates interoceptive signals and is critical for conscious awareness of bodily states.",
            functions: ["Interoception (body awareness)", "Disgust recognition", "Pain perception", "Empathy", "Taste processing", "Autonomic regulation", "Emotional awareness"],
            clinicalSignificance: "Insular lesions impair disgust recognition and interoceptive awareness. The insula is critical for conscious craving in addiction. Stroke affecting the insula can cause sudden cessation of smoking addiction.",
            associatedDisorders: ["Addiction (craving)", "Anxiety Disorders", "Eating Disorders", "Frontotemporal Dementia"],
            connections: ["amygdala", "cingulate-cortex", "prefrontal-cortex", "primary-auditory-cortex", "orbitofrontal-cortex"],
            brodmannAreas: [13, 14, 15, 16],
            lateralization: .bilateral,
            diagramView: .lateral
        ),

        // MARK: - Basal Ganglia (3)
        BrainStructure(
            id: "basal-ganglia-caudate",
            name: "Caudate Nucleus",
            region: .basalGanglia,
            aliases: ["Caudate"],
            description: "The caudate nucleus is a C-shaped structure that forms part of the striatum along with the putamen. It is primarily involved in cognitive and associative functions rather than direct motor control.",
            functions: ["Cognitive/procedural learning", "Goal-directed behavior", "Feedback-based learning", "Executive function support", "Working memory gating"],
            clinicalSignificance: "Caudate atrophy is the hallmark of Huntington's disease, producing chorea (involuntary dance-like movements), cognitive decline, and psychiatric symptoms. Also implicated in OCD circuitry.",
            associatedDisorders: ["Huntington's Disease", "OCD", "Tourette Syndrome", "ADHD"],
            connections: ["prefrontal-cortex", "basal-ganglia-putamen", "globus-pallidus", "thalamus"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "basal-ganglia-putamen",
            name: "Putamen",
            region: .basalGanglia,
            aliases: ["Lateral Striatum"],
            description: "The putamen is the outermost part of the basal ganglia, forming the lateral portion of the striatum. It is primarily involved in motor execution and habit-based (automatic) motor learning.",
            functions: ["Motor execution regulation", "Habit learning and automaticity", "Motor preparation", "Reinforcement learning"],
            clinicalSignificance: "The putamen receives dopaminergic input from the substantia nigra. Loss of this dopamine pathway is the primary cause of Parkinson's disease motor symptoms: bradykinesia, rigidity, resting tremor, and postural instability.",
            associatedDisorders: ["Parkinson's Disease", "Dystonia", "Huntington's Disease"],
            connections: ["primary-motor-cortex", "basal-ganglia-caudate", "globus-pallidus", "midbrain"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "globus-pallidus",
            name: "Globus Pallidus",
            region: .basalGanglia,
            aliases: ["Pallidum", "GP internal/external"],
            description: "The globus pallidus is the primary output nucleus of the basal ganglia, sending inhibitory projections to the thalamus. It has internal (GPi) and external (GPe) segments with distinct functions in the motor circuit.",
            functions: ["Motor output modulation", "Movement inhibition/facilitation", "Basal ganglia output relay", "Action selection"],
            clinicalSignificance: "Lesions can cause dystonia (sustained involuntary muscle contractions). Hemiballismus — violent flinging movements of the contralateral limbs — is classically caused by a lesion of the neighboring subthalamic nucleus, not the globus pallidus itself. Deep brain stimulation of the GPi is an established treatment for Parkinson's disease and dystonia.",
            associatedDisorders: ["Dystonia", "Parkinson's Disease"],
            connections: ["basal-ganglia-putamen", "basal-ganglia-caudate", "thalamus", "midbrain"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),

        // MARK: - Diencephalon (3)
        BrainStructure(
            id: "thalamus",
            name: "Thalamus",
            region: .diencephalon,
            aliases: ["Dorsal Thalamus"],
            description: "The thalamus is the brain's central relay station, a paired egg-shaped structure at the center of the brain. Nearly all sensory information (except olfaction) passes through specific thalamic nuclei before reaching the cortex.",
            functions: ["Sensory relay to cortex", "Consciousness gating", "Cortical arousal regulation", "Motor signal relay", "Attention and awareness modulation"],
            clinicalSignificance: "Thalamic lesions produce thalamic pain syndrome (Dejerine-Roussy): severe, burning contralateral pain. Fatal familial insomnia is caused by prion degeneration of the thalamus, leading to total insomnia and death.",
            associatedDisorders: ["Thalamic Pain Syndrome", "Fatal Familial Insomnia", "Thalamic Aphasia"],
            connections: ["primary-somatosensory-cortex", "primary-visual-cortex", "primary-auditory-cortex", "prefrontal-cortex", "hippocampus", "globus-pallidus", "cerebellum"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "hypothalamus",
            name: "Hypothalamus",
            region: .diencephalon,
            aliases: ["Hypo"],
            description: "The hypothalamus is a small but vital structure below the thalamus that controls the autonomic nervous system and endocrine system via the pituitary gland. It maintains homeostasis across multiple physiological systems.",
            functions: ["Homeostasis regulation", "Endocrine control via pituitary", "Autonomic nervous system regulation", "Hunger and satiety", "Thirst regulation", "Circadian rhythm (SCN)", "Body temperature regulation", "Sexual behavior"],
            clinicalSignificance: "Lesions cause diabetes insipidus (excessive urination from ADH deficiency), temperature dysregulation, disrupted sleep-wake cycles, and appetite disorders. Tumors (craniopharyngiomas) cause endocrine dysfunction.",
            associatedDisorders: ["Diabetes Insipidus", "Hypothalamic Obesity", "Sleep-Wake Disorders", "Endocrine Dysfunction"],
            connections: ["thalamus", "amygdala", "hippocampus", "mammillary-bodies", "brainstem-pons"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "pineal-gland",
            name: "Pineal Gland",
            region: .diencephalon,
            aliases: ["Epiphysis Cerebri", "Pineal Body"],
            description: "The pineal gland is a small endocrine gland in the epithalamus, situated between the two hemispheres near the center of the brain. It produces melatonin, regulating the sleep-wake cycle.",
            functions: ["Melatonin secretion", "Circadian rhythm regulation", "Sleep-wake cycle modulation", "Seasonal rhythm signaling"],
            clinicalSignificance: "Pineal tumors can compress the superior colliculus, causing Parinaud syndrome (paralysis of upward gaze). Calcification is normal with aging and visible on imaging, historically used as a midline landmark.",
            associatedDisorders: ["Parinaud Syndrome", "Sleep-Wake Disturbances", "Pineal Tumors"],
            connections: ["hypothalamus", "thalamus"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),

        // MARK: - Brainstem (4)
        BrainStructure(
            id: "midbrain",
            name: "Midbrain",
            region: .brainstem,
            aliases: ["Mesencephalon"],
            description: "The midbrain connects the pons and cerebellum with the forebrain. It contains the superior and inferior colliculi (visual and auditory reflexes), substantia nigra (dopamine), and cerebral peduncles (motor pathways).",
            functions: ["Visual reflexes (superior colliculus)", "Auditory reflexes (inferior colliculus)", "Dopamine production (substantia nigra)", "Eye movement control (CN III, IV)", "Pain modulation (PAG)"],
            clinicalSignificance: "Substantia nigra degeneration causes Parkinson's disease. Weber syndrome (CN III palsy + contralateral hemiparesis) and Benedikt syndrome result from midbrain vascular lesions.",
            associatedDisorders: ["Parkinson's Disease", "Weber Syndrome", "Benedikt Syndrome", "Progressive Supranuclear Palsy"],
            connections: ["basal-ganglia-putamen", "thalamus", "brainstem-pons", "cerebellum"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "brainstem-pons",
            name: "Pons",
            region: .brainstem,
            aliases: ["Metencephalon (partial)"],
            description: "The pons ('bridge') connects the cerebral cortex to the cerebellum and relays information between the two. It contains nuclei for sleep/arousal (locus coeruleus), cranial nerves V-VIII, and respiratory centers.",
            functions: ["Cortex-cerebellum relay", "Sleep and arousal regulation (locus coeruleus)", "Respiratory rhythm modulation", "Facial sensation and movement (CN V, VII)", "Hearing and balance relay (CN VIII)"],
            clinicalSignificance: "Pontine stroke can cause locked-in syndrome: complete paralysis except for vertical eye movements, with fully preserved consciousness. Central pontine myelinolysis results from rapid sodium correction.",
            associatedDisorders: ["Locked-in Syndrome", "Central Pontine Myelinolysis", "Trigeminal Neuralgia"],
            connections: ["midbrain", "medulla", "cerebellum", "thalamus"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "medulla",
            name: "Medulla Oblongata",
            region: .brainstem,
            aliases: ["Myelencephalon", "Medulla"],
            description: "The medulla oblongata is the most inferior part of the brainstem, continuous with the spinal cord. It contains vital cardiovascular and respiratory centers, and nuclei for cranial nerves IX-XII.",
            functions: ["Cardiovascular regulation", "Respiratory center", "Swallowing and vomiting reflexes", "Autonomic control", "Cranial nerve nuclei (IX-XII)", "Decussation of pyramidal tracts"],
            clinicalSignificance: "Damage to the medulla is often fatal due to loss of cardiovascular and respiratory control. Lateral medullary (Wallenberg) syndrome from PICA stroke causes vertigo, dysphagia, ipsilateral Horner syndrome, and crossed sensory loss.",
            associatedDisorders: ["Wallenberg Syndrome", "Respiratory Failure", "Bulbar Palsy"],
            connections: ["brainstem-pons", "cerebellum", "thalamus"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "reticular-formation",
            name: "Reticular Formation",
            region: .brainstem,
            aliases: ["ARAS", "Ascending Reticular Activating System"],
            description: "The reticular formation is a diffuse network of neurons spanning the brainstem core from medulla to midbrain. The ascending reticular activating system (ARAS) is essential for consciousness and arousal.",
            functions: ["Arousal and consciousness", "Sleep-wake cycle regulation", "Pain modulation", "Autonomic regulation", "Motor pattern generation", "Habituation to stimuli"],
            clinicalSignificance: "Damage to the ARAS is the primary cause of coma — unarousable unresponsiveness with absent sleep-wake cycles. Persistent vegetative state (unresponsive wakefulness syndrome) differs: it reflects cortical damage with a partially preserved ARAS, maintaining sleep-wake cycling without awareness. ARAS integrity distinguishes coma from brain death.",
            associatedDisorders: ["Coma", "Persistent Vegetative State", "Disorders of Consciousness", "Narcolepsy"],
            connections: ["thalamus", "hypothalamus", "midbrain", "brainstem-pons", "medulla"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),

        BrainStructure(
            id: "substantia-nigra",
            name: "Substantia Nigra",
            region: .brainstem,
            aliases: ["SN", "Substantia Nigra pars compacta/reticulata"],
            description: "The substantia nigra ('black substance') is a darkly pigmented midbrain nucleus containing dopaminergic neurons. The pars compacta (SNc) produces dopamine for the striatum; the pars reticulata (SNr) is a basal ganglia output nucleus.",
            functions: ["Dopamine production for striatum", "Motor control modulation", "Reward signaling", "Basal ganglia output (SNr)", "Movement initiation"],
            clinicalSignificance: "Degeneration of dopaminergic neurons in the SNc is the hallmark pathology of Parkinson's disease, causing the cardinal symptoms: bradykinesia, rigidity, resting tremor, and postural instability. Cell loss exceeds 60% before symptoms appear.",
            associatedDisorders: ["Parkinson's Disease", "Progressive Supranuclear Palsy", "Multiple System Atrophy"],
            connections: ["basal-ganglia-putamen", "basal-ganglia-caudate", "thalamus", "globus-pallidus"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "superior-colliculus",
            name: "Superior Colliculus",
            region: .brainstem,
            aliases: ["SC", "Optic Tectum"],
            description: "The superior colliculus is a layered structure on the dorsal midbrain (tectum) that integrates visual, auditory, and somatosensory information to coordinate reflexive eye and head movements toward stimuli.",
            functions: ["Visual reflexes (saccades)", "Multimodal sensory integration", "Orienting responses", "Visual attention direction", "Eye-head coordination"],
            clinicalSignificance: "Compression by pineal tumors causes Parinaud syndrome: paralysis of upward gaze, convergence-retraction nystagmus, and light-near dissociation of pupils. Critical for blindsight in cortically blind patients.",
            associatedDisorders: ["Parinaud Syndrome", "Dorsal Midbrain Syndrome"],
            connections: ["primary-visual-cortex", "frontal-eye-fields", "midbrain", "inferior-colliculus"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "inferior-colliculus",
            name: "Inferior Colliculus",
            region: .brainstem,
            aliases: ["IC"],
            description: "The inferior colliculus is a paired structure on the dorsal midbrain, inferior to the superior colliculus. It is a mandatory relay station in the ascending auditory pathway, integrating auditory information before it reaches the thalamus.",
            functions: ["Auditory relay and integration", "Sound localization", "Frequency analysis", "Auditory startle reflex", "Audiomotor integration"],
            clinicalSignificance: "Lesions cause contralateral hearing impairment and difficulty localizing sounds. Part of the ascending auditory pathway; damage disrupts the auditory startle reflex. Rarely affected in isolation.",
            associatedDisorders: ["Central Auditory Processing Disorder", "Sound Localization Deficits"],
            connections: ["primary-auditory-cortex", "superior-colliculus", "midbrain", "thalamus"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),

        // MARK: - Cerebellum (1)
        BrainStructure(
            id: "cerebellum",
            name: "Cerebellum",
            region: .cerebellum,
            aliases: ["Little Brain"],
            description: "The cerebellum sits posterior to the brainstem and contains more neurons than the rest of the brain combined. It coordinates movement timing, balance, and motor learning, and increasingly recognized for cognitive contributions.",
            functions: ["Motor coordination and timing", "Balance and posture", "Motor learning and adaptation", "Cognitive timing", "Error correction in movement", "Procedural memory"],
            clinicalSignificance: "Cerebellar lesions cause ataxia (uncoordinated movement), dysmetria (overshooting targets), intention tremor, nystagmus, and dysarthria (scanning speech). Cerebellar cognitive affective syndrome (Schmahmann syndrome) involves executive and emotional deficits.",
            associatedDisorders: ["Cerebellar Ataxia", "Schmahmann Syndrome", "Spinocerebellar Ataxia", "Medulloblastoma"],
            connections: ["primary-motor-cortex", "brainstem-pons", "thalamus", "premotor-cortex"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .both
        ),

        // MARK: - Diencephalon: Optic Chiasm
        BrainStructure(
            id: "optic-chiasm",
            name: "Optic Chiasm",
            region: .diencephalon,
            aliases: ["Chiasma Opticum"],
            description: "The optic chiasm is an X-shaped structure on the ventral surface of the brain where the optic nerves partially cross (decussate). Fibers from the nasal retina cross to the contralateral side, while temporal fibers remain ipsilateral.",
            functions: ["Partial crossing of optic nerve fibers", "Binocular visual field organization", "Nasal fiber decussation", "Visual pathway relay"],
            clinicalSignificance: "Compression by pituitary tumors causes bitemporal hemianopia (loss of peripheral vision in both eyes) — a classic neuro-ophthalmology finding. The characteristic visual field defect helps localize the lesion precisely.",
            associatedDisorders: ["Bitemporal Hemianopia", "Pituitary Adenoma", "Craniopharyngioma"],
            connections: ["primary-visual-cortex", "thalamus", "superior-colliculus"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),

        // MARK: - White Matter Tracts (1)
        BrainStructure(
            id: "corpus-callosum",
            name: "Corpus Callosum",
            region: .whiteTracts,
            aliases: ["CC", "Callosal Commissure"],
            description: "The corpus callosum is the largest white matter structure in the brain, containing approximately 200 million axons connecting the left and right cerebral hemispheres. It enables interhemispheric communication and coordination.",
            functions: ["Interhemispheric communication", "Bilateral motor coordination", "Transfer of sensory information", "Unified conscious experience", "Cognitive integration across hemispheres"],
            clinicalSignificance: "Surgical section (callosotomy for epilepsy) produces split-brain syndrome: each hemisphere operates independently, with fascinating dissociations in perception, language, and action. Agenesis causes subtle cognitive deficits.",
            associatedDisorders: ["Split-Brain Syndrome", "Alien Hand Syndrome", "Callosal Disconnection Syndrome", "Agenesis of Corpus Callosum"],
            connections: ["prefrontal-cortex", "primary-motor-cortex", "primary-somatosensory-cortex", "primary-visual-cortex"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "anterior-commissure",
            name: "Anterior Commissure",
            region: .whiteTracts,
            aliases: ["AC"],
            description: "The anterior commissure is a small white matter bundle crossing the midline anterior to the columns of the fornix. It connects the temporal lobes and olfactory structures of both hemispheres.",
            functions: ["Interhemispheric temporal lobe connection", "Olfactory information transfer", "Pain signal crossing", "Emotional memory transfer"],
            clinicalSignificance: "Though smaller than the corpus callosum, it provides critical interhemispheric connections for temporal lobe structures. In patients with callosal agenesis, the anterior commissure may partially compensate for missing callosal connections.",
            associatedDisorders: ["Disconnection Syndromes", "Callosal Agenesis (compensatory)"],
            connections: ["corpus-callosum", "amygdala", "hippocampus", "orbitofrontal-cortex"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        ),
        BrainStructure(
            id: "lateral-ventricle",
            name: "Lateral Ventricle",
            region: .whiteTracts,
            aliases: ["Ventriculus Lateralis"],
            description: "The lateral ventricles are C-shaped cavities within each cerebral hemisphere, containing cerebrospinal fluid (CSF). They have frontal (anterior), body, occipital (posterior), and temporal (inferior) horns following the C-shape of the hemisphere.",
            functions: ["CSF production and circulation", "Brain cushioning and protection", "Waste removal", "Nutrient transport", "Intracranial pressure regulation"],
            clinicalSignificance: "Ventricular enlargement (ventriculomegaly) is seen in hydrocephalus, schizophrenia, and neurodegenerative diseases. Normal pressure hydrocephalus (NPH) presents with the triad of gait disturbance, urinary incontinence, and dementia — a treatable cause of dementia.",
            associatedDisorders: ["Hydrocephalus", "Normal Pressure Hydrocephalus", "Schizophrenia (enlarged ventricles)"],
            connections: ["corpus-callosum", "fornix", "hippocampus", "thalamus"],
            brodmannAreas: nil,
            lateralization: .bilateral,
            diagramView: .medial
        )
    ]

    static func structure(byID id: String) -> BrainStructure? {
        all.first { $0.id == id }
    }

    static func structures(inRegion region: BrainRegion) -> [BrainStructure] {
        all.filter { $0.region == region }
    }

    static func structures(forView view: DiagramView) -> [BrainStructure] {
        all.filter { $0.diagramView == view || $0.diagramView == .both }
    }

    static func search(_ query: String) -> [BrainStructure] {
        let lowered = query.lowercased()
        return all.filter { structure in
            structure.name.lowercased().contains(lowered) ||
            structure.aliases.contains { $0.lowercased().contains(lowered) } ||
            structure.functions.contains { $0.lowercased().contains(lowered) } ||
            structure.associatedDisorders.contains { $0.lowercased().contains(lowered) }
        }
    }
}
