float4 ColorCorrectBottomOffset : register(c44);
float4 ColorCorrectBottomOffsetScreenEdge : register(c67);
float4 ColorCorrectTopAndPedReflectScale : register(c43);
float4 ColorCorrectTopScreenEdge : register(c66);
float4 ColorShift : register(c45);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
float4 gDepthFxParams : register(c18);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalFogColorN : register(c50);
float4 globalFogParams : register(c37);
float4 globalScalars : register(c35);
float4 globalScalars4 : register(c51);
float4 globalScreenSize : register(c41);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float3 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	float3 r4;
	float2 r5;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r0.xyz = r0.xyz + -gViewInverse[3].xyz;
	r0.w = r0.z * globalFogParams.x;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * globalFogParams.z;
	r0.y = r0.w * -1.442695;
	r0.y = exp2(r0.y);
	r0.y = min(r0.y, 65504);
	r0.y = -r0.y + 1;
	r0.z = 1 / r0.w;
	r0.w = (0.0001 < abs(r0.w)) ? 1 : 0;
	r0.y = r0.z * r0.y;
	r0.y = r0.x * r0.y + -r0.x;
	r0.x = r0.w * r0.y + r0.x;
	r0.x = r0.x * -globalFogParams.y;
	r0.x = r0.x * 1.442695;
	r0.x = exp2(r0.x);
	r0.x = min(r0.x, 1);
	r0.yzw = globalScalars.yyy * i.color.xyz;
	r0.y = dot(r0.yzw, float3(0.2125, 0.7154, 0.0721));
	r0.z = r0.y + 1E-05;
	r0.z = abs(r0.z) + 1E-05;
	r1 = gWorldViewProj[1] * i.position.y;
	r1 = i.position.x * gWorldViewProj[0] + r1;
	r1 = i.position.z * gWorldViewProj[2] + r1;
	r1 = r1 + gWorldViewProj[3];
	r0.w = saturate(-r1.w * gDepthFxParams.z + gDepthFxParams.w);
	r2.x = -r0.w + 1;
	r2.xy = r2.xx * gDepthFxParams.xy + r0.ww;
	r0.w = r2.y + -0.99999;
	r2.y = pow(r0.z, r0.w);
	r3 = i.color.xyz * globalScalars.yyy + -r0.yyy;
	r0.yzw = r2.xxx * r3.xyz + r0.yyy;
	r0.yzw = r0.yzw * r2.yyy + -globalFogColorN.xyz;
	r0.xyz = r0.xxx * r0.yzw + globalFogColorN.xyz;
	r0.w = dot(r0.xyz, float3(0.2125, 0.7154, 0.0721));
	r2.x = gAdrenoFXVars.x;
	r2.x = r2.x * deSatContrastGamma.x;
	r3 = lerp(r0.www, r0.xyz, r2.xxx);
	r0.x = r0.w * ColorCorrectBottomOffset.w;
	r0.y = r0.w * ColorShift.w;
	r2.xyz = globalScalars4.yzw * -r0.xxx + r3.xyz;
	r3 = ColorShift.xyz * -r0.yyy + r3.xyz;
	r4 = r0.xxx * globalScalars4.yzw;
	r0.x = saturate(r0.x);
	r0.xzw = r0.xxx * r2.xyz + r4.xyz;
	r2 = ColorCorrectTopScreenEdge;
	r2.xyz = r1.yyy * ColorCorrectBottomOffsetScreenEdge.xyz + r2.xyz;
	r0.xzw = r0.xzw * r2.xyz;
	r2.xyz = r0.yyy * ColorShift.xyz;
	r0.y = saturate(r0.y);
	r2.xyz = r0.yyy * r3.xyz + r2.xyz;
	r3 = ColorCorrectBottomOffset.xyz;
	r3 = r1.yyy * r3.xyz + ColorCorrectTopAndPedReflectScale.xyz;
	r4 = r2.xyz * r3.xyz;
	r0.y = 1 / globalScreenSize.x;
	r5.x = r0.y * r1.x;
	r0.y = 1 / globalScreenSize.y;
	r5.y = r0.y * r1.y;
	o.position = r1;
	r1.xy = r5.xy + -0.5;
	r1.xy = r1.xy * r1.xy;
	r0.y = r1.y + r1.x;
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	r1.x = r2.w + -ColorCorrectBottomOffsetScreenEdge.w;
	r1.x = max(r1.x, 0);
	r1.y = r0.y + -r1.x;
	r0.y = (r0.y < r1.x) ? 1 : 0;
	r1.x = -r1.x + ColorCorrectTopScreenEdge.w;
	r1.x = 1 / r1.x;
	r1.x = saturate(r1.x * r1.y);
	r0.y = r0.y * -r1.x + r1.x;
	r1.xyz = lerp(r4.xyz, r0.xzw, r0.yyy);
	r0.xyz = r2.xyz * -r3.xyz + r1.xyz;
	r0.w = (r2.w >= 0) ? 1 : 0;
	o.texcoord = r0.www * r0.xyz + r4.xyz;

	return o;
}
