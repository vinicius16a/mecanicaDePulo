//
//  GameScene.swift
//  mecanicaDePulo
//
//  Created by Vinicius Bruno on 09/07/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var playerNode: SKSpriteNode?
    override init(size: CGSize) {
        super.init(size: size )
        
        self.createBackground(with: CGPoint(x: size.width*0.50, y: size.height*0.55))
        
        //cria um chao e colloca fisica nele-----------------------------------------------------------
        let chao = SKSpriteNode(color: .red, size: CGSize(width: size.width, height: size.height*0.04))
        chao.position.y = 0
        chao.position.x = size.width*0.5
        let body = SKPhysicsBody(rectangleOf: chao.size)
        body.affectedByGravity =  true
        body.allowsRotation = false
        body.isDynamic = false
        chao.physicsBody = body
        self.addChild(chao)
        
        
        let teto = SKSpriteNode(color: .red, size: CGSize(width: size.width, height: size.height*0.04))
        teto.position.y = size.height
        teto.position.x = size.width*0.5
        let bodyTeto = SKPhysicsBody(rectangleOf: teto.size)
        bodyTeto.affectedByGravity = true
        bodyTeto.allowsRotation = false
        bodyTeto.isDynamic = false
        
        teto.physicsBody = bodyTeto
        self.addChild(teto)
        //----------------------------------------------------------------------------------------------
        
        
        
        //criando um personagem e aplicando fisica nele-------------------------------------------------
//        playerNode.setScale(0.25)
//        playerNode.position = CGPoint(x: size.width*0.15, y: size.height*0.17)
//        playerNode.name = "dino"
//        let body2 = SKPhysicsBody(rectangleOf:  playerNode.size)
//        body2.affectedByGravity = true
//        body2.allowsRotation = false
//        playerNode.physicsBody = body2
//        self.addChild(playerNode)
        
        
        self.playerNode = criarPlayer(position: CGPoint(x: size.width*0.15, y: size.height*0.17))
        self.addChild(playerNode!)
        playerNode!.run(.repeatForever(.animate(with: .init(format: "Run (%@)", frameCount: 1...8), timePerFrame: 0.1)))
        //----------------------------------------------------------------------------------------------
        
    
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        //let playerNode = criarPlayer(position: CGPoint(x: size.width*0.15, y: size.height*0.17))
//        playerNode?.run(.repeatForever(.animate(with: .init(format: "Idle (%@)", frameCount: 1...10), timePerFrame: 0.1)))
//
//        playerNode!.run(.repeatForever(.animate(with: .init(format: "Run (%@)", frameCount: 1...8), timePerFrame: 0.1)))
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Recupero a referência para o toque
        let touch = touches.first
        
        // Recupero a posição do toque com referência à minha scene. À minha tela.
        guard let touchLocation = touch?.location(in: self) else { return }
        
        // Procuro saber se existe um node na posição do toque.
        guard let node = self.nodes(at: touchLocation).first else { return }
        
        print(node)
        
       // playerNode.removeAllActions()
        playerNode!.run((.animate(with: .init(format: "Jump (%@)", frameCount: 1...12), timePerFrame: 0.05)))
        var direcao: CGFloat
        if touchLocation.x < size.width/2 {
            direcao = -1
            if playerNode!.xScale > 0{
                playerNode!.xScale = playerNode!.xScale*(-1)
            }
        }else{
            direcao = 1
            if playerNode!.xScale < 0{
                playerNode!.xScale = playerNode!.xScale*(-1)
            }
        }
        var gravidade: CGFloat
        if touchLocation.y > size.height/2 {
            gravidade = -1
            if playerNode!.yScale > 0{
                playerNode!.yScale = playerNode!.xScale*(-1)
            }
            physicsWorld.gravity.dy = 9.0

        }else{
            gravidade = 1
            if playerNode!.yScale < 0{
                playerNode!.yScale = playerNode!.xScale*(-1)
            }
            physicsWorld.gravity.dy = -9.0
        }
       // playerNode!.xScale = playerNode!.xScale*(direcao)
        playerNode!.physicsBody?.applyImpulse(CGVector(dx: CGFloat(direcao)*(playerNode!.size.width*0.25), dy: CGFloat(gravidade)*(playerNode!.size.height*0.25)*3))
     
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //criando background
    func createBackground(with position: CGPoint) {
        
        // Declaro minha constante de background. Um Sprite que vem do arquivo Background.png
        let background = SKSpriteNode(imageNamed: "fundoCimiterio")
        
        // Insiro a Posição (X, Y) ao meu node.
        background.position = position
        
        // A ZPosition (posição Z [profundidade]) é definida. Por ser um background, ele ficará atrás de tudo.
        background.zPosition = -1
        
        // Altero diretamente a escala X e Y (largura e altura) do nosso background para 275% do tamanho original
        background.setScale(1.75)
        
        // Retiro o Anti-Aliasing (redutor de serrilhado [por ser pixel art])
        background.texture?.filteringMode = .nearest
        
        // Adiciono meu sprite (background) como filho da cena, para ele ser renderizado.
        self.addChild(background)
        
    }
    
    //criando o dino  **************************tentar resolver isso depois************************
    func criarPlayer(position: CGPoint) -> SKSpriteNode {
        let playerNode = SKSpriteNode(imageNamed: "Idle (1)")
        playerNode.setScale(0.25)
        playerNode.position = position
        playerNode.name = "dino"
        let body = SKPhysicsBody(texture: SKTexture(imageNamed: "Idle (1)"), size: playerNode.size)
        body.affectedByGravity = true
        body.allowsRotation = false
        playerNode.physicsBody = body
        
        
        return playerNode
    }
}


extension Array where Element == SKTexture{
    init(format: String, frameCount: ClosedRange<Int>){
        self = frameCount.map({ (index) in
            let imageName = String(format: format, "\(index)")
            return SKTexture(imageNamed: imageName)
        })
        
    }
}


