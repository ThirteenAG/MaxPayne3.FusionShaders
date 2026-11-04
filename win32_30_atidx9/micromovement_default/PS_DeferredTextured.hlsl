sampler2D DiffuseSampler : register(s0);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDistFadeParams : register(c97);
float4 gStencil : register(c61);
row_major float4x4 gViewInverse : register(c12);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord6 : TEXCOORD6;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.x = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.y = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2.xyz = lerp(r0.yyy, r1.xyz, gAdrenoFXVars.xxx);
	r3 = lerp(r1.xyz, r2.xyz, r0.xxx);
	r0.x = r1.w * i.color.w;
	r0.y = saturate(-1 + i.color.x);
	o.color.xyz = r0.yyy * globalScalars2.zzz + r3.xyz;
	r0.yzw = 1E-05 + i.texcoord1.xyz;
	r1.xyz = normalize(r0.yzw);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r1.xzw = float3(-1, -0.5, 0);
	r0.y = r0.x * globalScalars.x + r1.z;
	r0.x = r0.x * globalScalars.x;
	r2 = min(r0.y, 0);
	r0.y = (r0.y >= 0) ? 1 : r0.x;
	clip(r2);
	r2.xyz = -gViewInverse[3].xyz + i.texcoord6.xyz;
	r0.z = dot(r2.xyz, r2.xyz);
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	r0.zw = r0.zz + float2(-0.65, -0.9);
	r0.z = saturate(r0.z);
	r0.z = r0.z + -1;
	r0.z = (r0.w >= 0) ? r0.z : -0.75;
	r0.z = gDistFadeParams.x * r0.z + -r1.x;
	o.color.w = r0.z * r0.y;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color2.xyz = i.color.xxx * float3(0, 0, 1) + float3(0, 0.25, 0);
	o.color3 = abs(r1.wwwx) * gStencil.x;

	return o;
}
