import SceneKit
import SwiftUI

// MARK: - Brain 3D Scene Builder

final class Brain3DScene {

    // MARK: - Public Interface

    static func makeScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = nil

        let rootNode = scene.rootNode

        // Brain tissue
        let brainNode = buildBrainMesh()
        rootNode.addChildNode(brainNode)

        // Lobe color overlays
        for lobeNode in buildLobeOverlays() {
            rootNode.addChildNode(lobeNode)
        }

        // Invisible structure hit-test markers
        for (structureID, position) in Brain3DPositions.positions {
            let markerNode = makeMarkerNode(structureID: structureID, at: position)
            rootNode.addChildNode(markerNode)
        }

        // Lighting
        for lightNode in buildLights() {
            rootNode.addChildNode(lightNode)
        }

        return scene
    }

    // MARK: - Brain Mesh

    private static func buildBrainMesh() -> SCNNode {
        let container = SCNNode()
        container.name = "brain_mesh"

        let brainColor = brainTissueColor()

        // Left hemisphere
        let leftHemi = SCNSphere(radius: 1.0)
        leftHemi.segmentCount = 48
        leftHemi.firstMaterial = brainMaterial(color: brainColor)
        let leftNode = SCNNode(geometry: leftHemi)
        leftNode.name = "left_hemisphere"
        leftNode.scale = SCNVector3(0.92, 0.80, 1.05)
        leftNode.position = SCNVector3(-0.28, 0.0, 0.0)
        container.addChildNode(leftNode)

        // Right hemisphere
        let rightHemi = SCNSphere(radius: 1.0)
        rightHemi.segmentCount = 48
        rightHemi.firstMaterial = brainMaterial(color: brainColor)
        let rightNode = SCNNode(geometry: rightHemi)
        rightNode.name = "right_hemisphere"
        rightNode.scale = SCNVector3(0.92, 0.80, 1.05)
        rightNode.position = SCNVector3(0.28, 0.0, 0.0)
        container.addChildNode(rightNode)

        // Cerebellum
        let cerebellarGeom = SCNSphere(radius: 0.42)
        cerebellarGeom.segmentCount = 32
        cerebellarGeom.firstMaterial = brainMaterial(color: cerebellarColor())
        let cerebellumNode = SCNNode(geometry: cerebellarGeom)
        cerebellumNode.name = "cerebellum_mesh"
        cerebellumNode.scale = SCNVector3(1.20, 0.68, 0.90)
        cerebellumNode.position = SCNVector3(0.0, -0.88, -0.72)
        container.addChildNode(cerebellumNode)

        // Brainstem
        let stemGeom = SCNCylinder(radius: 0.115, height: 0.55)
        stemGeom.radialSegmentCount = 16
        stemGeom.firstMaterial = brainMaterial(color: brainstemColor())
        let stemNode = SCNNode(geometry: stemGeom)
        stemNode.name = "brainstem_mesh"
        stemNode.position = SCNVector3(0.0, -0.92, -0.12)
        stemNode.eulerAngles = SCNVector3(Float.pi / 12, 0, 0) // tilt forward 15°
        container.addChildNode(stemNode)

        // Interhemispheric fissure (dark groove between hemispheres)
        let fissureGeom = SCNBox(width: 0.06, height: 1.8, length: 1.85, chamferRadius: 0.02)
        let fissureMaterial = SCNMaterial()
        fissureMaterial.diffuse.contents = fissureColor()
        fissureMaterial.lightingModel = .phong
        fissureGeom.firstMaterial = fissureMaterial
        let fissureNode = SCNNode(geometry: fissureGeom)
        fissureNode.name = "fissure"
        fissureNode.position = SCNVector3(0.0, 0.05, 0.0)
        container.addChildNode(fissureNode)

        return container
    }

    // MARK: - Lobe Color Overlays

    private static func buildLobeOverlays() -> [SCNNode] {
        struct LobeSpec {
            let name: String
            let position: SCNVector3
            let scale: SCNVector3
            let color: NativeColor
        }

        let specs: [LobeSpec] = [
            // Frontal lobe — warm blue
            LobeSpec(name: "overlay_frontal_left",
                     position: SCNVector3(-0.40, 0.30, 0.72),
                     scale: SCNVector3(0.62, 0.58, 0.55),
                     color: NativeColor(red: 0.28, green: 0.52, blue: 0.90, alpha: 0.18)),
            // Parietal lobe — teal/green
            LobeSpec(name: "overlay_parietal_left",
                     position: SCNVector3(-0.42, 0.72, -0.10),
                     scale: SCNVector3(0.55, 0.42, 0.52),
                     color: NativeColor(red: 0.22, green: 0.78, blue: 0.62, alpha: 0.18)),
            // Temporal lobe — warm amber
            LobeSpec(name: "overlay_temporal_left",
                     position: SCNVector3(-0.70, -0.12, 0.02),
                     scale: SCNVector3(0.38, 0.42, 0.52),
                     color: NativeColor(red: 0.95, green: 0.65, blue: 0.22, alpha: 0.18)),
            // Occipital lobe — soft purple
            LobeSpec(name: "overlay_occipital",
                     position: SCNVector3( 0.00, 0.22, -0.78),
                     scale: SCNVector3(0.62, 0.42, 0.30),
                     color: NativeColor(red: 0.65, green: 0.32, blue: 0.88, alpha: 0.18)),
            // Limbic — rose
            LobeSpec(name: "overlay_limbic_left",
                     position: SCNVector3(-0.32, -0.22, -0.02),
                     scale: SCNVector3(0.28, 0.28, 0.28),
                     color: NativeColor(red: 0.95, green: 0.35, blue: 0.52, alpha: 0.22)),
        ]

        return specs.map { spec in
            let geom = SCNSphere(radius: 1.0)
            geom.segmentCount = 24
            let mat = SCNMaterial()
            mat.diffuse.contents = spec.color
            mat.lightingModel = .constant
            mat.isDoubleSided = true
            mat.transparency = 0.72
            geom.firstMaterial = mat
            let node = SCNNode(geometry: geom)
            node.name = spec.name
            node.scale = spec.scale
            node.position = spec.position
            node.renderingOrder = -1
            return node
        }
    }

    // MARK: - Structure Marker Nodes

    static func makeMarkerNode(structureID: String, at position: SCNVector3) -> SCNNode {
        // Invisible hit-test sphere
        let geom = SCNSphere(radius: 0.14)
        geom.segmentCount = 8
        let mat = SCNMaterial()
        mat.diffuse.contents = NativeColor.clear
        mat.transparency = 0.0
        geom.firstMaterial = mat
        let node = SCNNode(geometry: geom)
        node.name = structureID
        node.position = position
        node.opacity = 0.01 // near-invisible but still hit-testable
        return node
    }

    /// Creates a visible selection indicator sphere at a given position
    static func makeSelectionIndicator(color: NativeColor, at position: SCNVector3) -> SCNNode {
        let geom = SCNSphere(radius: 0.10)
        geom.segmentCount = 16
        let mat = SCNMaterial()
        mat.diffuse.contents = color.withAlphaComponent(0.85)
        mat.emission.contents = color.withAlphaComponent(0.45)
        mat.lightingModel = .phong
        geom.firstMaterial = mat
        let node = SCNNode(geometry: geom)
        node.name = "selection_indicator"
        node.position = position

        // Animated scale-in
        node.scale = SCNVector3(0.01, 0.01, 0.01)
        let scaleAction = SCNAction.scale(to: 1.0, duration: 0.25)
        scaleAction.timingMode = .easeOut
        node.runAction(scaleAction)

        // Subtle pulse
        let pulse = SCNAction.sequence([
            SCNAction.scale(to: 1.12, duration: 0.8),
            SCNAction.scale(to: 0.88, duration: 0.8)
        ])
        node.runAction(SCNAction.repeatForever(pulse), forKey: "pulse")

        return node
    }

    // MARK: - Lighting

    private static func buildLights() -> [SCNNode] {
        var nodes: [SCNNode] = []

        // Ambient — warm white fill
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = NativeColor(white: 0.92, alpha: 1.0)
        ambientLight.intensity = 350
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        nodes.append(ambientNode)

        // Key light — directional from top-left-front, casts soft shadows
        let keyLight = SCNLight()
        keyLight.type = .directional
        keyLight.color = NativeColor(red: 1.0, green: 0.97, blue: 0.92, alpha: 1.0)
        keyLight.intensity = 750
        keyLight.castsShadow = true
        keyLight.shadowMode = .deferred
        keyLight.shadowSampleCount = 8
        keyLight.shadowRadius = 4
        let keyNode = SCNNode()
        keyNode.light = keyLight
        keyNode.eulerAngles = SCNVector3(-Float.pi / 4.5, -Float.pi / 4, 0) // top-left
        nodes.append(keyNode)

        // Fill light — dim, from bottom-right
        let fillLight = SCNLight()
        fillLight.type = .directional
        fillLight.color = NativeColor(red: 0.75, green: 0.85, blue: 1.0, alpha: 1.0)
        fillLight.intensity = 180
        let fillNode = SCNNode()
        fillNode.light = fillLight
        fillNode.eulerAngles = SCNVector3(Float.pi / 5, Float.pi * 0.8, 0) // bottom-right
        nodes.append(fillNode)

        // Rim light — back-right edge highlight
        let rimLight = SCNLight()
        rimLight.type = .directional
        rimLight.color = NativeColor(red: 0.85, green: 0.92, blue: 1.0, alpha: 1.0)
        rimLight.intensity = 140
        let rimNode = SCNNode()
        rimNode.light = rimLight
        rimNode.eulerAngles = SCNVector3(Float.pi / 8, Float.pi * 1.2, 0)
        nodes.append(rimNode)

        return nodes
    }

    // MARK: - Materials

    private static func brainMaterial(color: NativeColor) -> SCNMaterial {
        let mat = SCNMaterial()
        mat.diffuse.contents = color
        mat.specular.contents = NativeColor(white: 0.22, alpha: 1.0)
        mat.shininess = 0.12
        mat.lightingModel = .phong
        mat.isDoubleSided = false
        return mat
    }

    // MARK: - Platform Colors

    private static func brainTissueColor() -> NativeColor {
        NativeColor(red: 0.80, green: 0.68, blue: 0.64, alpha: 1.0)
    }

    private static func cerebellarColor() -> NativeColor {
        NativeColor(red: 0.74, green: 0.62, blue: 0.58, alpha: 1.0)
    }

    private static func brainstemColor() -> NativeColor {
        NativeColor(red: 0.70, green: 0.60, blue: 0.56, alpha: 1.0)
    }

    private static func fissureColor() -> NativeColor {
        NativeColor(red: 0.50, green: 0.40, blue: 0.38, alpha: 1.0)
    }
}

// MARK: - Platform Color Alias

#if os(iOS) || os(watchOS) || os(tvOS)
typealias NativeColor = UIColor
#elseif os(macOS)
typealias NativeColor = NSColor
#endif
