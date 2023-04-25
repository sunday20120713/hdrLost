var TouchInput=pc.createScript("touchInput");TouchInput.attributes.add("orbitSensitivity",{type:"number",default:.4,title:"Orbit Sensitivity",description:"How fast the camera moves around the orbit. Higher is faster"}),TouchInput.attributes.add("distanceSensitivity",{type:"number",default:.2,title:"Distance Sensitivity",description:"How fast the camera moves in and out. Higher is faster"}),TouchInput.prototype.initialize=function(){this.orbitCamera=this.entity.script.orbitCamera,this.lastTouchPoint=new pc.Vec2,this.lastPinchMidPoint=new pc.Vec2,this.lastPinchDistance=0,this.orbitCamera&&this.app.touch&&(this.app.touch.on(pc.EVENT_TOUCHSTART,this.onTouchStartEndCancel,this),this.app.touch.on(pc.EVENT_TOUCHEND,this.onTouchStartEndCancel,this),this.app.touch.on(pc.EVENT_TOUCHCANCEL,this.onTouchStartEndCancel,this),this.app.touch.on(pc.EVENT_TOUCHMOVE,this.onTouchMove,this),this.on("destroy",(function(){this.app.touch.off(pc.EVENT_TOUCHSTART,this.onTouchStartEndCancel,this),this.app.touch.off(pc.EVENT_TOUCHEND,this.onTouchStartEndCancel,this),this.app.touch.off(pc.EVENT_TOUCHCANCEL,this.onTouchStartEndCancel,this),this.app.touch.off(pc.EVENT_TOUCHMOVE,this.onTouchMove,this)})))},TouchInput.prototype.getPinchDistance=function(t,i){var o=t.x-i.x,n=t.y-i.y;return Math.sqrt(o*o+n*n)},TouchInput.prototype.calcMidPoint=function(t,i,o){o.set(i.x-t.x,i.y-t.y),o.scale(.5),o.x+=t.x,o.y+=t.y},TouchInput.prototype.onTouchStartEndCancel=function(t){var i=t.touches;1==i.length?this.lastTouchPoint.set(i[0].x,i[0].y):2==i.length&&(this.lastPinchDistance=this.getPinchDistance(i[0],i[1]),this.calcMidPoint(i[0],i[1],this.lastPinchMidPoint))},TouchInput.fromWorldPoint=new pc.Vec3,TouchInput.toWorldPoint=new pc.Vec3,TouchInput.worldDiff=new pc.Vec3,TouchInput.prototype.pan=function(t){var i=TouchInput.fromWorldPoint,o=TouchInput.toWorldPoint,n=TouchInput.worldDiff,h=this.entity.camera,c=this.orbitCamera.distance;h.screenToWorld(t.x,t.y,c,i),h.screenToWorld(this.lastPinchMidPoint.x,this.lastPinchMidPoint.y,c,o),n.sub2(o,i),this.orbitCamera.pivotPoint.add(n)},TouchInput.pinchMidPoint=new pc.Vec2,TouchInput.prototype.onTouchMove=function(t){var i=TouchInput.pinchMidPoint,o=t.touches;if(1==o.length){var n=o[0];this.orbitCamera.pitch-=(n.y-this.lastTouchPoint.y)*this.orbitSensitivity,this.orbitCamera.yaw-=(n.x-this.lastTouchPoint.x)*this.orbitSensitivity,this.lastTouchPoint.set(n.x,n.y)}else if(2==o.length){var h=this.getPinchDistance(o[0],o[1]),c=h-this.lastPinchDistance;this.lastPinchDistance=h,this.orbitCamera.distance-=c*this.distanceSensitivity*.1*(.1*this.orbitCamera.distance),this.calcMidPoint(o[0],o[1],i),this.pan(i),this.lastPinchMidPoint.copy(i)}};var OrbitCamera=pc.createScript("orbitCamera");OrbitCamera.attributes.add("autoRender",{type:"boolean",default:!0,title:"Auto Render",description:"Disable to only render when camera is moving (saves power when the camera is still)"}),OrbitCamera.attributes.add("useMultiFrame",{type:"boolean",default:!1,title:"Multi Frame",description:"Enable to use multiframe super sampling to smooth edges when camera is still"}),OrbitCamera.attributes.add("distanceMax",{type:"number",default:0,title:"Distance Max",description:"Setting this at 0 will give an infinite distance limit"}),OrbitCamera.attributes.add("distanceMin",{type:"number",default:0,title:"Distance Min"}),OrbitCamera.attributes.add("pitchAngleMax",{type:"number",default:90,title:"Pitch Angle Max (degrees)"}),OrbitCamera.attributes.add("pitchAngleMin",{type:"number",default:-90,title:"Pitch Angle Min (degrees)"}),OrbitCamera.attributes.add("inertiaFactor",{type:"number",default:0,title:"Inertia Factor",description:"Higher value means that the camera will continue moving after the user has stopped dragging. 0 is fully responsive."}),OrbitCamera.attributes.add("focusEntity",{type:"entity",title:"Focus Entity",description:"Entity for the camera to focus on. If blank, then the camera will use the whole scene"}),OrbitCamera.attributes.add("frameOnStart",{type:"boolean",default:!0,title:"Frame on Start",description:'Frames the entity or scene at the start of the application."'}),Object.defineProperty(OrbitCamera.prototype,"distance",{get:function(){return this._targetDistance},set:function(t){this._targetDistance=this._clampDistance(t)}}),Object.defineProperty(OrbitCamera.prototype,"pitch",{get:function(){return this._targetPitch},set:function(t){this._targetPitch=this._clampPitchAngle(t)}}),Object.defineProperty(OrbitCamera.prototype,"yaw",{get:function(){return this._targetYaw},set:function(t){this._targetYaw=t;var i=(this._targetYaw-this._yaw)%360;this._targetYaw=i>180?this._yaw-(360-i):i<-180?this._yaw+(360+i):this._yaw+i}}),Object.defineProperty(OrbitCamera.prototype,"pivotPoint",{get:function(){return this._pivotPoint},set:function(t){this._pivotPoint.copy(t)}}),OrbitCamera.prototype.focus=function(t){this._buildAabb(t,0);var i=this._modelsAabb.halfExtents,e=Math.max(i.x,Math.max(i.y,i.z));e/=Math.tan(.5*this.entity.camera.fov*pc.math.DEG_TO_RAD),e*=2,this.distance=e,this._removeInertia(),this._pivotPoint.copy(this._modelsAabb.center)},OrbitCamera.distanceBetween=new pc.Vec3,OrbitCamera.prototype.resetAndLookAtPoint=function(t,i){this.pivotPoint.copy(i),this.entity.setPosition(t),this.entity.lookAt(i);var e=OrbitCamera.distanceBetween;e.sub2(i,t),this.distance=e.length(),this.pivotPoint.copy(i);var a=this.entity.getRotation();this.yaw=this._calcYaw(a),this.pitch=this._calcPitch(a,this.yaw),this._removeInertia(),this._updatePosition(),this.autoRender||(this.app.renderNextFrame=!0)},OrbitCamera.prototype.resetAndLookAtEntity=function(t,i){this._buildAabb(i,0),this.resetAndLookAtPoint(t,this._modelsAabb.center)},OrbitCamera.prototype.reset=function(t,i,e){this.pitch=i,this.yaw=t,this.distance=e,this._removeInertia(),this.autoRender||(this.app.renderNextFrame=!0)},OrbitCamera.prototype.initialize=function(){this._checkAspectRatio(),this._modelsAabb=new pc.BoundingBox,this._buildAabb(this.focusEntity||this.app.root,0),this.entity.lookAt(this._modelsAabb.center),this._pivotPoint=new pc.Vec3,this._pivotPoint.copy(this._modelsAabb.center),this._lastFramePivotPoint=this._pivotPoint.clone();var t=this.entity.getRotation();if(this._yaw=this._calcYaw(t),this._pitch=this._clampPitchAngle(this._calcPitch(t,this._yaw)),this.entity.setLocalEulerAngles(this._pitch,this._yaw,0),this._distance=0,this._targetYaw=this._yaw,this._targetPitch=this._pitch,this.frameOnStart)this.focus(this.focusEntity||this.app.root);else{var i=new pc.Vec3;i.sub2(this.entity.getPosition(),this._pivotPoint),this._distance=this._clampDistance(i.length())}this._targetDistance=this._distance,this._autoRenderDefault=this.app.autoRender,this._firstFrame=!0,this.app.autoRender&&(this.app.autoRender=this.autoRender),this.autoRender||(this.app.renderNextFrame=!0),this._multiframeBusy=!1,this.useMultiFrame&&(this._multiframe=new Multiframe(this.app.graphicsDevice,this.entity.camera,5)),this.on("attr:autoRender",(function(t,i){this.app.autoRender=t,this.autoRender||(this.app.renderNextFrame=!0)}),this),this.on("attr:distanceMin",(function(t,i){this._targetDistance=this._clampDistance(this._distance)}),this),this.on("attr:distanceMax",(function(t,i){this._targetDistance=this._clampDistance(this._distance)}),this),this.on("attr:pitchAngleMin",(function(t,i){this._targetPitch=this._clampPitchAngle(this._pitch)}),this),this.on("attr:pitchAngleMax",(function(t,i){this._targetPitch=this._clampPitchAngle(this._pitch)}),this),this.on("attr:focusEntity",(function(t,i){this.frameOnStart?this.focus(t||this.app.root):this.resetAndLookAtEntity(this.entity.getPosition(),t||this.app.root)}),this),this.on("attr:frameOnStart",(function(t,i){t&&this.focus(this.focusEntity||this.app.root)}),this);var onResizeCanvas=function(){if(this._multiframe){var t=this.app.graphicsDevice,i={width:t.canvas.width/t.maxPixelRatio,height:t.height/t.maxPixelRatio};this.autoRender||(this.app.renderNextFrame=!0),this._multiframe.moved();var createTexture=(i,e,a)=>new pc.Texture(t,{width:i,height:e,format:a,mipmaps:!1,minFilter:pc.FILTER_NEAREST,magFilter:pc.FILTER_NEAREST,addressU:pc.ADDRESS_CLAMP_TO_EDGE,addressV:pc.ADDRESS_CLAMP_TO_EDGE}),e=this.entity.camera.renderTarget;e&&(e.colorBuffer.destroy(),e.depthBuffer.destroy(),e.destroy());var a=i.width,s=i.height,r=createTexture(a,s,pc.PIXELFORMAT_R8_G8_B8_A8),n=createTexture(a,s,pc.PIXELFORMAT_DEPTH),h=new pc.RenderTarget({colorBuffer:r,depthBuffer:n,flipY:!1,samples:t.maxSamples});this.entity.camera.renderTarget=h,this._checkAspectRatio(),this.autoRender||(this.app.renderNextFrame=!0)}},onPostRender=function(){this._multiframe&&(this._multiframeBusy=this._multiframe.update())},onFrameEnd=function(){this._firstFrame&&(this._firstFrame=!1,this.autoRender||(this.app.renderNextFrame=!0)),this._multiframeBusy&&!this.autoRender&&(this.app.renderNextFrame=!0)};this.app.graphicsDevice.on("resizecanvas",onResizeCanvas,this),this.app.on("postrender",onPostRender,this),this.app.on("frameend",onFrameEnd,this),this.on("destroy",(function(){this.app.graphicsDevice.off("resizecanvas",onResizeCanvas,this),this.app.off("postrender",onPostRender,this),this.app.off("frameend",onFrameEnd,this),this.app.autoRender=this._defaultAutoRender;var t=this.entity.camera.renderTarget;t&&(this.entity.camera.renderTarget=null,t.destroy())}),this),onResizeCanvas.call(this)},OrbitCamera.prototype.update=function(t){var i=Math.abs(this._targetDistance-this._distance),e=Math.abs(this._targetYaw-this._yaw),a=Math.abs(this._targetPitch-this._pitch),s=this.pivotPoint.distance(this._lastFramePivotPoint),r=i>.001||e>.01||a>.01||s>.001;this.autoRender||(this.app.renderNextFrame=r||this.app.renderNextFrame);var n=0===this.inertiaFactor?1:Math.min(t/this.inertiaFactor,1);this._distance=pc.math.lerp(this._distance,this._targetDistance,n),this._yaw=pc.math.lerp(this._yaw,this._targetYaw,n),this._pitch=pc.math.lerp(this._pitch,this._targetPitch,n),this._lastFramePivotPoint.copy(this.pivotPoint),this._updatePosition(),r&&this._multiframe&&this._multiframe.moved()},OrbitCamera.prototype._updatePosition=function(){this.entity.setLocalPosition(0,0,0),this.entity.setLocalEulerAngles(this._pitch,this._yaw,0);var t=this.entity.getPosition();t.copy(this.entity.forward),t.scale(-this._distance),t.add(this.pivotPoint),this.entity.setPosition(t)},OrbitCamera.prototype._removeInertia=function(){this._yaw=this._targetYaw,this._pitch=this._targetPitch,this._distance=this._targetDistance},OrbitCamera.prototype._checkAspectRatio=function(){var t=this.app.graphicsDevice.height,i=this.app.graphicsDevice.width;this.entity.camera.horizontalFov=t>i},OrbitCamera.prototype._buildAabb=function(t,i){var e,a=0,s=0;if(t instanceof pc.Entity){var r=[],n=t.findComponents("render");for(a=0;a<n.length;++a)if(e=n[a].meshInstances)for(s=0;s<e.length;s++)r.push(e[s]);var h=t.findComponents("model");for(a=0;a<h.length;++a)if(e=h[a].meshInstances)for(s=0;s<e.length;s++)r.push(e[s]);for(a=0;a<r.length;a++)0===i?this._modelsAabb.copy(r[a].aabb):this._modelsAabb.add(r[a].aabb),i+=1}for(a=0;a<t.children.length;++a)i+=this._buildAabb(t.children[a],i);return i},OrbitCamera.prototype._calcYaw=function(t){var i=new pc.Vec3;return t.transformVector(pc.Vec3.FORWARD,i),Math.atan2(-i.x,-i.z)*pc.math.RAD_TO_DEG},OrbitCamera.prototype._clampDistance=function(t){return this.distanceMax>0?pc.math.clamp(t,this.distanceMin,this.distanceMax):Math.max(t,this.distanceMin)},OrbitCamera.prototype._clampPitchAngle=function(t){return pc.math.clamp(t,-this.pitchAngleMax,-this.pitchAngleMin)},OrbitCamera.quatWithoutYaw=new pc.Quat,OrbitCamera.yawOffset=new pc.Quat,OrbitCamera.prototype._calcPitch=function(t,i){var e=OrbitCamera.quatWithoutYaw,a=OrbitCamera.yawOffset;a.setFromEulerAngles(0,-i,0),e.mul2(a,t);var s=new pc.Vec3;return e.transformVector(pc.Vec3.FORWARD,s),Math.atan2(s.y,-s.z)*pc.math.RAD_TO_DEG};var MouseInput=pc.createScript("mouseInput");MouseInput.attributes.add("orbitSensitivity",{type:"number",default:.3,title:"Orbit Sensitivity",description:"How fast the camera moves around the orbit. Higher is faster"}),MouseInput.attributes.add("distanceSensitivity",{type:"number",default:.15,title:"Distance Sensitivity",description:"How fast the camera moves in and out. Higher is faster"}),MouseInput.prototype.initialize=function(){if(this.orbitCamera=this.entity.script.orbitCamera,this.orbitCamera){var t=this,onMouseOut=function(o){t.onMouseOut(o)};this.app.mouse.on(pc.EVENT_MOUSEDOWN,this.onMouseDown,this),this.app.mouse.on(pc.EVENT_MOUSEUP,this.onMouseUp,this),this.app.mouse.on(pc.EVENT_MOUSEMOVE,this.onMouseMove,this),this.app.mouse.on(pc.EVENT_MOUSEWHEEL,this.onMouseWheel,this),window.addEventListener("mouseout",onMouseOut,!1),this.on("destroy",(function(){this.app.mouse.off(pc.EVENT_MOUSEDOWN,this.onMouseDown,this),this.app.mouse.off(pc.EVENT_MOUSEUP,this.onMouseUp,this),this.app.mouse.off(pc.EVENT_MOUSEMOVE,this.onMouseMove,this),this.app.mouse.off(pc.EVENT_MOUSEWHEEL,this.onMouseWheel,this),window.removeEventListener("mouseout",onMouseOut,!1)}))}this.app.mouse.disableContextMenu(),this.lookButtonDown=!1,this.panButtonDown=!1,this.lastPoint=new pc.Vec2},MouseInput.fromWorldPoint=new pc.Vec3,MouseInput.toWorldPoint=new pc.Vec3,MouseInput.worldDiff=new pc.Vec3,MouseInput.prototype.pan=function(t){var o=MouseInput.fromWorldPoint,e=MouseInput.toWorldPoint,i=MouseInput.worldDiff,s=this.entity.camera,n=this.orbitCamera.distance;s.screenToWorld(t.x,t.y,n,o),s.screenToWorld(this.lastPoint.x,this.lastPoint.y,n,e),i.sub2(e,o),this.orbitCamera.pivotPoint.add(i)},MouseInput.prototype.onMouseDown=function(t){switch(t.button){case pc.MOUSEBUTTON_LEFT:this.lookButtonDown=!0;break;case pc.MOUSEBUTTON_MIDDLE:case pc.MOUSEBUTTON_RIGHT:this.panButtonDown=!0}},MouseInput.prototype.onMouseUp=function(t){switch(t.button){case pc.MOUSEBUTTON_LEFT:this.lookButtonDown=!1;break;case pc.MOUSEBUTTON_MIDDLE:case pc.MOUSEBUTTON_RIGHT:this.panButtonDown=!1}},MouseInput.prototype.onMouseMove=function(t){pc.app.mouse;this.lookButtonDown?(this.orbitCamera.pitch-=t.dy*this.orbitSensitivity,this.orbitCamera.yaw-=t.dx*this.orbitSensitivity):this.panButtonDown&&this.pan(t),this.lastPoint.set(t.x,t.y)},MouseInput.prototype.onMouseWheel=function(t){this.orbitCamera.distance-=t.wheel*this.distanceSensitivity*(.1*this.orbitCamera.distance),t.event.preventDefault()},MouseInput.prototype.onMouseOut=function(t){this.lookButtonDown=!1,this.panButtonDown=!1};var KeyboardInput=pc.createScript("keyboardInput");KeyboardInput.prototype.initialize=function(){this.orbitCamera=this.entity.script.orbitCamera},KeyboardInput.prototype.postInitialize=function(){this.orbitCamera&&(this.startDistance=this.orbitCamera.distance,this.startYaw=this.orbitCamera.yaw,this.startPitch=this.orbitCamera.pitch,this.startPivotPosition=this.orbitCamera.pivotPoint.clone())},KeyboardInput.prototype.update=function(t){this.orbitCamera&&this.app.keyboard.wasPressed(pc.KEY_SPACE)&&(this.orbitCamera.reset(this.startYaw,this.startPitch,this.startDistance),this.orbitCamera.pivotPoint=this.startPivotPosition)};!function(){var vertexShaderHeader=function(e){return e.webgl2?"#version 300 es\n\n".concat(pc.shaderChunks.gles3VS,"\n"):""},fragmentShaderHeader=function(e){return(e.webgl2?"#version 300 es\n\n".concat(pc.shaderChunks.gles3PS,"\n"):"")+"precision ".concat(e.precision," float;\n\n")},gauss=function(e,t){return 1/(Math.sqrt(2*Math.PI)*t)*Math.exp(-e*e/(2*t*t))},e=new pc.BlendState(!0,pc.BLENDEQUATION_ADD,pc.BLENDMODE_CONSTANT,pc.BLENDMODE_ONE_MINUS_CONSTANT),t=new pc.BlendState(!1),r=function(){function Multiframe(e,t,r){var i=this;this.shader=null,this.multiframeTexUniform=null,this.powerUniform=null,this.textureBiasUniform=null,this.accumTexture=null,this.accumRenderTarget=null,this.sampleId=0,this.samples=[],this.enabled=!0,this.totalWeight=0,this.device=e,this.camera=t,this.textureBias=-Math.log2(r),this.samples=this.generateSamples(r,!1,2,0),this.camera.onPreRender=function(){var e=i.camera.camera,t=e.projectionMatrix;if(i.enabled&&i.accumTexture){var r=i.samples[i.sampleId];t.data[8]=r.x/i.accumTexture.width,t.data[9]=r.y/i.accumTexture.height,i.textureBiasUniform.setValue(0===i.sampleId?0:i.textureBias)}else t.data[8]=0,t.data[9]=0,i.textureBiasUniform.setValue(0);e._viewProjMatDirty=!0},this.shader=new pc.Shader(e,{attributes:{vertex_position:pc.SEMANTIC_POSITION},vshader:vertexShaderHeader(e)+"\nattribute vec2 vertex_position;\nvarying vec2 texcoord;\nvoid main(void) {\n    gl_Position = vec4(vertex_position, 0.5, 1.0);\n    texcoord = vertex_position.xy * 0.5 + 0.5;\n}\n",fshader:fragmentShaderHeader(e)+"\nvarying vec2 texcoord;\nuniform sampler2D multiframeTex;\nuniform float power;\nvoid main(void) {\n    vec4 t = texture2D(multiframeTex, texcoord);\n    gl_FragColor = pow(t, vec4(power));\n}\n"}),this.pixelFormat=function(e){return function(e){return e.extTextureHalfFloat&&e.textureHalfFloatRenderable}(e)?pc.PIXELFORMAT_RGBA16F:function(e){return e.extTextureFloat&&e.textureFloatRenderable}(e)?pc.PIXELFORMAT_RGBA32F:pc.PIXELFORMAT_RGBA8}(e),this.multiframeTexUniform=e.scope.resolve("multiframeTex"),this.powerUniform=e.scope.resolve("power"),this.textureBiasUniform=e.scope.resolve("textureBias");var handler=function(){i.destroy()};e.once("destroy",handler),e.on("devicelost",handler)}return Multiframe.prototype.setSamples=function(e,t,r,i){void 0===t&&(t=!1),void 0===r&&(r=1),void 0===i&&(i=0),this.textureBias=-Math.log2(e),this.samples=this.generateSamples(e,t,r,i),this.sampleId=0},Multiframe.prototype.generateSamples=function(e,t,r,i){void 0===t&&(t=!1),void 0===r&&(r=1),void 0===i&&(i=0);for(var a,s,n,o=[],u=Math.ceil(3*i)+1,h=.5*r,c=0;c<e;++c)for(var l=0;l<e;++l)t?(a=(c+Math.random())/e*2-1,s=(l+Math.random())/e*2-1):(a=c/(e-1)*2-1,s=l/(e-1)*2-1),n=i<=0?1:gauss(a*u,i)*gauss(s*u,i),o.push(new pc.Vec3(a*h,s*h,n));var m=0;return o.forEach((function(e){m+=e.z})),o.forEach((function(e){e.z/=m})),o.sort((function(e,t){var r=e.length(),i=t.length();return r<i?-1:i<r?1:0})),o},Multiframe.prototype.destroy=function(){this.accumRenderTarget&&(this.accumRenderTarget.destroy(),this.accumRenderTarget=null),this.accumTexture&&(this.accumTexture.destroy(),this.accumTexture=null)},Multiframe.prototype.create=function(){var e=this.camera.renderTarget.colorBuffer;this.accumTexture=new pc.Texture(this.device,{width:e.width,height:e.height,format:this.pixelFormat,mipmaps:!1,minFilter:pc.FILTER_NEAREST,magFilter:pc.FILTER_NEAREST}),this.accumRenderTarget=new pc.RenderTarget({colorBuffer:this.accumTexture,depth:!1})},Multiframe.prototype.moved=function(){this.sampleId=0,this.totalWeight=0},Multiframe.prototype.update=function(){var r=this.device,i=this.samples.length,a=this.camera.renderTarget.colorBuffer;if(r.setBlendState(t),!this.enabled)return this.multiframeTexUniform.setValue(a),this.powerUniform.setValue(1),(0,pc.drawQuadWithShader)(r,null,this.shader),this.activateBackbuffer(),!1;if(!this.accumTexture||this.accumTexture.width===a.width&&this.accumTexture.height===a.height||this.destroy(),this.accumTexture||this.create(),this.sampleId<i){var s=this.samples[this.sampleId].z,n=s/(this.totalWeight+s);r.setBlendState(e),r.setBlendColor(n,n,n,n),this.multiframeTexUniform.setValue(a),this.powerUniform.setValue(2.2),(0,pc.drawQuadWithShader)(r,this.accumRenderTarget,this.shader,null,null),this.totalWeight+=s,r.setBlendState(t)}return 0===this.sampleId?(this.multiframeTexUniform.setValue(a),this.powerUniform.setValue(1)):(this.multiframeTexUniform.setValue(this.accumTexture),this.powerUniform.setValue(1/2.2)),(0,pc.drawQuadWithShader)(r,null,this.shader),this.sampleId<i&&this.sampleId++,this.activateBackbuffer(),this.sampleId<i},Multiframe.prototype.activateBackbuffer=function(){var e=this.device;e.setRenderTarget(null),e.updateBegin(),e.setViewport(0,0,e.width,e.height),e.setScissor(0,0,e.width,e.height)},Multiframe.prototype.copy=function(e){var t=this.device;this.multiframeTexUniform.setValue(this.accumTexture),this.powerUniform.setValue(1/2.2),(0,pc.drawQuadWithShader)(t,e,this.shader)},Multiframe}();window.Multiframe=r}();var LoadGlb=pc.createScript("loadGlb");LoadGlb.attributes.add("url",{type:"string"}),LoadGlb.prototype.initialize=function(){var t=this;utils.loadGlbContainerFromUrl(this.url,null,"glb-asset",(function(a,r){var e=r.resource.instantiateRenderEntity();t.entity.addChild(e),t.app.renderNextFrame=!0}))};!function(){var n={},e=pc.Application.getApplication();n.loadGlbContainerFromAsset=function(n,t,o,a){var r=function(n){var e=new Blob([n.resource]),r=URL.createObjectURL(e);return this.loadGlbContainerFromUrl(r,t,o,(function(n,e){a(n,e),URL.revokeObjectURL(r)}))}.bind(this);n.ready(r),e.assets.load(n)},n.loadGlbContainerFromUrl=function(n,t,o,a){var r=o+".glb",i={url:n,filename:r},l=new pc.Asset(r,"container",i,null,t);return l.once("load",(function(n){if(a){var e=n.resource.animations;if(1==e.length)e[0].name=o;else if(e.length>1)for(var t=0;t<e.length;++t)e[t].name=o+" "+t.toString();a(null,n)}})),e.assets.add(l),e.assets.load(l),l},window.utils=n}();