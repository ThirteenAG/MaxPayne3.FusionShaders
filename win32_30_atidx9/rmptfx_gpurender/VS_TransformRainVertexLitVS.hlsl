float gAmbientAmount : register(c102);
float4 gAmbientOcclusionEffect : register(c63);
float4 gColorTint : register(c96);
float4 gColorTintPhase2 : register(c98);
float gDiffuse : register(c101);
float4 gLightAmbient0 : register(c33);
float4 gLightAmbient1 : register(c34);
float4 gRadius : register(c93);
float4 gTextureAnimation : register(c95);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldView : register(c4);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float3 r5;
	if (-abs(i.texcoord1.w) >= abs(i.texcoord1.w)) {
		r0.x = gRadius.x;
		r0.y = r0.x * 0.125;
		r0.xzw = r0.xxx * float3(0, 0, 0.5) + i.texcoord.xyz;
		r1.xy = float2(-0.5, -0.7) + i.texcoord2.xy;
		r2.xyz = normalize(i.texcoord1.xyz);
		r3.xyz = -r0.xzw + gViewInverse[3].xyz;
		r4.xyz = r2.zxy * r3.yzx;
		r4.xyz = r2.yzx * r3.zxy + -r4.xyz;
		r5 = normalize(r4.xyz);
		r4.xyz = r0.yyy * r5.xyz;
		r2.xyz = r2.xyz * gRadius.xxx;
		r1.yzw = r1.yyy * r2.xyz;
		r1.xyz = r1.xxx * r4.xyz + r1.yzw;
		r2.xyz = normalize(r3.xyz);
		r0.xyz = r0.xzw + r1.xyz;
		r1 = r0.y * gWorldViewProj[1];
		r1 = r0.x * gWorldViewProj[0] + r1;
		r0 = r0.z * gWorldViewProj[2] + r1;
		o.position = r0 + gWorldViewProj[3];
		r0 = gColorTint;
		r1.x = i.texcoord2.x;
	} else {
		r1.z = gRadius.z;
		r3 = r1.z * float4(0, 0, 0.5, 0) + i.texcoord;
		r1.zw = -0.5 + i.texcoord2.xy;
		r4.xyz = normalize(gViewInverse[0].xyz);
		r4.xyz = r4.xyz * gRadius.zzz;
		r5 = normalize(-gViewInverse[1].xyz);
		r5 = r5.xyz * gRadius.zzz;
		r5 = r1.www * r5.xyz;
		r4.xyz = r1.zzz * r4.xyz + r5.xyz;
		r2.xyz = normalize(r4.xyz);
		r3.xyz = r3.xyz + r4.xyz;
		r4 = r3.y * gWorldViewProj[1];
		r4 = r3.x * gWorldViewProj[0] + r4;
		r4 = r3.z * gWorldViewProj[2] + r4;
		o.position = r4 + gWorldViewProj[3];
		r1.z = r3.w * gTextureAnimation.x + -gTextureAnimation.y;
		r1.w = frac(r1.z);
		r2.w = r1.z + -r1.w;
		r1.z = (r1.z < -r1.z) ? 1 : 0;
		r1.w = (-r1.w < r1.w) ? 1 : 0;
		r1.z = r1.z * r1.w + r2.w;
		r1.z = saturate(r1.z * gTextureAnimation.z);
		r1.z = gTextureAnimation.z * i.texcoord2.x + r1.z;
		r1.x = r1.z + -10;
		r0 = gColorTintPhase2;
	}
	r1.z = dot(r2.xyz, gWorldView[2].xyz);
	r1.z = saturate(r1.z * -0.5 + 0.5);
	r2.xyz = gLightAmbient0.xyz;
	r2.xyz = -r2.xyz + gLightAmbient1.xyz;
	r2.xyz = r1.zzz * r2.xyz + gLightAmbient0.xyz;
	r2.xyz = r2.xyz * gAmbientAmount.xxx;
	r1.z = 1 / gAmbientOcclusionEffect.y;
	r2.xyz = r1.zzz * r2.xyz;
	r2.xyz = r2.xyz * gDiffuse.xxx;
	o.color.xyz = r0.xyz * r2.xyz;
	r0.xyz = gViewInverse[3].xyz + -i.texcoord.xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * 0.6666667;
	r0.y = r0.x * r0.x;
	r0.x = r0.x * r0.y;
	r0.x = min(r0.x, 1);
	o.color.w = r0.x * r0.w;
	r1.y = i.texcoord2.y;
	o.texcoord = r1.xy;

	return o;
}
