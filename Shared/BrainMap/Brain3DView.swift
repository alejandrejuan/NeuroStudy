import SwiftUI
import SceneKit

// MARK: - SwiftUI Bridge

/// Fully 3D, rotatable, tappable brain using SceneKit.
/// Works on iOS, iPadOS, and macOS.
struct Brain3DSceneView: View {
    @Bindable var viewModel: Brain3DViewModel
    var onStructureTapped: ((String) -> Void)?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Brain3DRepresentable(viewModel: viewModel, onStructureTapped: onStructureTapped)
            .aspectRatio(4/3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                .white.opacity(colorScheme == .dark ? 0.12 : 0.40),
                                .white.opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.45 : 0.18), radius: 24, y: 10)
    }
}

// MARK: - iOS / iPadOS Representable

#if os(iOS)
struct Brain3DRepresentable: UIViewRepresentable {
    @Bindable var viewModel: Brain3DViewModel
    var onStructureTapped: ((String) -> Void)?

    func makeUIView(context: Context) -> SCNView {
        let scnView = Brain3DRepresentable.configuredSCNView()
        scnView.scene = Brain3DScene.makeScene()
        context.coordinator.scnView = scnView
        context.coordinator.setupGestures(on: scnView)
        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        context.coordinator.update(selectedID: viewModel.selectedID,
                                   highlightedIDs: viewModel.highlightedIDs,
                                   isQuizMode: viewModel.isQuizMode)
    }

    func makeCoordinator() -> Brain3DCoordinator {
        Brain3DCoordinator(viewModel: viewModel, onStructureTapped: onStructureTapped)
    }

    private static func configuredSCNView() -> SCNView {
        let view = SCNView()
        view.backgroundColor = .clear
        view.autoenablesDefaultLighting = false
        view.antialiasingMode = .multisampling4X
        view.preferredFramesPerSecond = 60
        view.rendersContinuously = false
        view.allowsCameraControl = false
        // Default camera
        let camera = SCNCamera()
        camera.fieldOfView = 42
        camera.zNear = 0.1
        camera.zFar = 100
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0.12, 3.8)
        cameraNode.name = "main_camera"
        view.scene?.rootNode.addChildNode(cameraNode)
        view.pointOfView = cameraNode
        return view
    }
}

// MARK: - macOS Representable

#elseif os(macOS)
struct Brain3DRepresentable: NSViewRepresentable {
    @Bindable var viewModel: Brain3DViewModel
    var onStructureTapped: ((String) -> Void)?

    func makeNSView(context: Context) -> SCNView {
        let scnView = Brain3DRepresentable.configuredSCNView()
        scnView.scene = Brain3DScene.makeScene()
        context.coordinator.scnView = scnView
        context.coordinator.setupGestures(on: scnView)
        return scnView
    }

    func updateNSView(_ nsView: SCNView, context: Context) {
        context.coordinator.update(selectedID: viewModel.selectedID,
                                   highlightedIDs: viewModel.highlightedIDs,
                                   isQuizMode: viewModel.isQuizMode)
    }

    func makeCoordinator() -> Brain3DCoordinator {
        Brain3DCoordinator(viewModel: viewModel, onStructureTapped: onStructureTapped)
    }

    private static func configuredSCNView() -> SCNView {
        let view = SCNView()
        view.backgroundColor = .clear
        view.autoenablesDefaultLighting = false
        view.antialiasingMode = .multisampling4X
        view.preferredFramesPerSecond = 60
        view.rendersContinuously = false
        view.allowsCameraControl = false
        let camera = SCNCamera()
        camera.fieldOfView = 42
        camera.zNear = 0.1
        camera.zFar = 100
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0.12, 3.8)
        cameraNode.name = "main_camera"
        view.scene?.rootNode.addChildNode(cameraNode)
        view.pointOfView = cameraNode
        return view
    }
}
#endif

// MARK: - Shared Coordinator

final class Brain3DCoordinator: NSObject {
    weak var scnView: SCNView?
    let viewModel: Brain3DViewModel
    let onStructureTapped: ((String) -> Void)?

    // Rotation state
    private var rotationEulerY: Float = 0.18  // slight initial angle
    private var rotationEulerX: Float = -0.12
    private var previousPanTranslation: CGPoint = .zero
    private var velocity: CGPoint = .zero

    // Nodes
    private var brainRootNode: SCNNode?
    private var selectionIndicatorNode: SCNNode?

    init(viewModel: Brain3DViewModel, onStructureTapped: ((String) -> Void)?) {
        self.viewModel = viewModel
        self.onStructureTapped = onStructureTapped
        super.init()
    }

    // MARK: - Gesture Setup

    func setupGestures(on view: SCNView) {
        // Store reference to the brain root container for rotation
        brainRootNode = view.scene?.rootNode

        // Apply initial rotation for a pleasing angle
        brainRootNode?.eulerAngles = SCNVector3(rotationEulerX, rotationEulerY, 0)

        #if os(iOS)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(pinchGesture)
        #elseif os(macOS)
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        let panGesture = NSPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let magnifyGesture = NSMagnificationGestureRecognizer(target: self, action: #selector(handleMagnify(_:)))
        view.addGestureRecognizer(clickGesture)
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(magnifyGesture)
        #endif
    }

    // MARK: - Tap / Click

    #if os(iOS)
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let scnView = scnView else { return }
        let location = gesture.location(in: scnView)
        handleTapAt(location, in: scnView)
    }
    #elseif os(macOS)
    @objc private func handleClick(_ gesture: NSClickGestureRecognizer) {
        guard let scnView = scnView else { return }
        let location = gesture.location(in: scnView)
        handleTapAt(location, in: scnView)
    }
    #endif

    private func handleTapAt(_ location: CGPoint, in scnView: SCNView) {
        let hitResults = scnView.hitTest(location, options: [
            SCNHitTestOption.searchMode: SCNHitTestSearchMode.closest.rawValue,
            SCNHitTestOption.ignoreHiddenNodes: false
        ])

        // Find first result that maps to a brain structure
        for result in hitResults {
            let name = result.node.name ?? ""
            if Brain3DPositions.positions[name] != nil {
                triggerSelection(structureID: name)
                return
            }
        }

        // Tapped empty space — deselect
        viewModel.clearSelection()
        removeSelectionIndicator()
    }

    private func triggerSelection(structureID: String) {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif

        if let handler = onStructureTapped {
            handler(structureID)
        } else {
            viewModel.select(structureID)
        }

        updateSelectionIndicator(structureID: structureID)
    }

    // MARK: - Pan Rotation

    #if os(iOS)
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let scnView = scnView else { return }
        let translation = gesture.translation(in: scnView)
        let delta = CGPoint(
            x: translation.x - previousPanTranslation.x,
            y: translation.y - previousPanTranslation.y
        )

        switch gesture.state {
        case .began:
            previousPanTranslation = translation
            scnView.rendersContinuously = true
        case .changed:
            let sensitivity: Float = 0.008
            rotationEulerY += Float(delta.x) * sensitivity
            rotationEulerX += Float(delta.y) * sensitivity
            // Clamp vertical rotation to prevent flipping
            rotationEulerX = max(-Float.pi / 2.5, min(Float.pi / 2.5, rotationEulerX))
            brainRootNode?.eulerAngles = SCNVector3(rotationEulerX, rotationEulerY, 0)
            previousPanTranslation = translation
            velocity = delta
        case .ended, .cancelled:
            previousPanTranslation = .zero
            scnView.rendersContinuously = false
            // Momentum decay
            applyMomentum()
        default:
            break
        }
    }

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let scnView = scnView, let camera = scnView.pointOfView else { return }
        if gesture.state == .changed {
            let currentZ = camera.position.z
            let newZ = Float(currentZ) / Float(gesture.scale)
            camera.position.z = max(2.0, min(6.0, newZ))
            gesture.scale = 1.0
        }
    }
    #elseif os(macOS)
    @objc private func handlePan(_ gesture: NSPanGestureRecognizer) {
        guard let scnView = scnView else { return }
        let translation = gesture.translation(in: scnView)
        let delta = CGPoint(
            x: translation.x - previousPanTranslation.x,
            y: translation.y - previousPanTranslation.y
        )

        switch gesture.state {
        case .began:
            previousPanTranslation = translation
            scnView.rendersContinuously = true
        case .changed:
            let sensitivity: Float = 0.008
            rotationEulerY += Float(delta.x) * sensitivity
            rotationEulerX += Float(delta.y) * sensitivity
            rotationEulerX = max(-Float.pi / 2.5, min(Float.pi / 2.5, rotationEulerX))
            brainRootNode?.eulerAngles = SCNVector3(rotationEulerX, rotationEulerY, 0)
            previousPanTranslation = translation
            velocity = delta
        case .ended, .cancelled:
            previousPanTranslation = .zero
            scnView.rendersContinuously = false
            applyMomentum()
        default:
            break
        }
    }

    @objc private func handleMagnify(_ gesture: NSMagnificationGestureRecognizer) {
        guard let camera = scnView?.pointOfView else { return }
        if gesture.state == .changed {
            let currentZ = camera.position.z
            let newZ = currentZ * CGFloat(1 - gesture.magnification * 0.5)
            camera.position.z = max(2.0, min(6.0, newZ))
            gesture.magnification = 0
        }
    }
    #endif

    private func applyMomentum() {
        guard abs(velocity.x) > 0.5 || abs(velocity.y) > 0.5 else { return }
        let decayFactor: CGFloat = 0.88
        var steps = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }
            self.velocity.x *= decayFactor
            self.velocity.y *= decayFactor
            let sensitivity: Float = 0.006
            self.rotationEulerY += Float(self.velocity.x) * sensitivity
            self.rotationEulerX += Float(self.velocity.y) * sensitivity
            self.rotationEulerX = max(-Float.pi / 2.5, min(Float.pi / 2.5, self.rotationEulerX))
            self.brainRootNode?.eulerAngles = SCNVector3(self.rotationEulerX, self.rotationEulerY, 0)
            steps += 1
            if (abs(self.velocity.x) < 0.1 && abs(self.velocity.y) < 0.1) || steps > 120 {
                timer.invalidate()
                self.scnView?.rendersContinuously = false
            }
        }
        RunLoop.main.add(timer, forMode: .common)
    }

    // MARK: - Selection Indicator

    private func updateSelectionIndicator(structureID: String) {
        guard let scene = scnView?.scene else { return }
        removeSelectionIndicator()

        let position = Brain3DPositions.position(for: structureID)
        let regionColor: NativeColor = {
            if let structure = BrainStructureStore.structure(byID: structureID) {
                return platformColor(from: structure.region.color)
            }
            return NativeColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 1.0)
        }()

        let indicator = Brain3DScene.makeSelectionIndicator(color: regionColor, at: position)
        scene.rootNode.addChildNode(indicator)
        selectionIndicatorNode = indicator
        scnView?.rendersContinuously = false
        #if os(iOS)
        scnView?.setNeedsDisplay()
        #else
        scnView?.needsDisplay = true
        #endif
    }

    private func removeSelectionIndicator() {
        selectionIndicatorNode?.removeFromParentNode()
        selectionIndicatorNode = nil
    }

    // MARK: - State Updates (from SwiftUI)

    func update(selectedID: String?, highlightedIDs: Set<String>, isQuizMode: Bool) {
        if selectedID == nil {
            removeSelectionIndicator()
        } else if let id = selectedID, selectionIndicatorNode == nil {
            updateSelectionIndicator(structureID: id)
        }
    }

    // MARK: - Helpers

    private func platformColor(from swiftUIColor: Color) -> NativeColor {
        #if os(iOS)
        return UIColor(swiftUIColor)
        #elseif os(macOS)
        return NSColor(swiftUIColor)
        #else
        return .white
        #endif
    }
}
