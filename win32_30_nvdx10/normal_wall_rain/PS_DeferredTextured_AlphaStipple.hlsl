sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
float4 RainNormalControls : register(c201);
sampler2D RainNormalSampler : register(s2);
float4 WetDarken : register(c200);
float bumpiness : register(c198);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 gWaterGlobals : register(c64);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float specularColorFactor : register(c197);
float specularFactor : register(c196);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float2 vpos : VPOS;
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
	float4 r3;
	float3 r4;
	float2 r5;
	float4 r6;
	float3 r7;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.w = r0.w * i.color.w;
	r1.x = r0.w * globalScalars.x;
	r1.yz = 0.5 * i.vpos.xy;
	r1.yz = frac(abs(r1.yz));
	r1.yz = (i.vpos.xy >= 0) ? r1.yz : -r1.yz;
	r1.yz = r1.yz + r1.yz;
	r2.xy = frac(r1.yz);
	r1.yz = r1.yz + -r2.xy;
	r1.y = r1.z * 2 + r1.y;
	r2 = r1.y + float4(-0, -1, -2, -3);
	r2 = (-abs(r2) >= 0) ? 1 : 0;
	r1.y = dot(stipplePattern, r2);
	r0.w = r0.w * -globalScalars.x + r1.y;
	r2 = (r0.w >= 0) ? -1 : -0;
	clip(r2);
	r2 = tex2D(BumpSampler, i.texcoord.xy);
	r0.w = -r2.w + 1;
	r0.w = -r2.x + r0.w;
	r1.yz = (r0.ww >= 0) ? r2.wy : r2.xy;
	r1.yz = r1.yz * 2 + -1;
	r2.xy = r1.yz * bumpiness.xx;
	r0.w = dot(r2.xy, -r2.xy) + 1;
	r1.y = max(r0.w, 0);
	r0.w = rsqrt(r1.y);
	r2.z = 1 / r0.w;
	r1.zw = float2(1, 0);
	r3.y = max(r1.z, specularFactor.x);
	r0.w = saturate(gWaterGlobals.y + -i.color.y);
	r4 = r0.xyz * WetDarken.xyz;
	r3.z = gWaterGlobals.z;
	r5.x = lerp(specularColorFactor.x, r3.z, r0.w);
	r5.y = lerp(r3.y, gWaterGlobals.w, r0.w);
	r1.y = globalScalars2.y;
	r3.zw = r1.yy * RainNormalControls.zw;
	r3.zw = i.texcoord.xy * RainNormalControls.xy + r3.zw;
	r6 = tex2D(RainNormalSampler, r3.zw);
	r1.y = -r6.w + 1;
	r1.y = -r6.x + r1.y;
	r3.zw = (r1.yy >= 0) ? r6.wy : r6.xy;
	r3.zw = r3.zw * 2 + -1;
	r6.xy = r3.zw * WetDarken.ww;
	r1.y = dot(r6.xy, -r6.xy) + 1;
	r2.w = max(r1.y, 0);
	r1.y = rsqrt(r2.w);
	r6.z = 1 / r1.y;
	r7 = lerp(r2.xyz, r6.xyz, r0.www);
	r6.xyz = r7.xyz + 1E-05;
	r7 = normalize(r6.xyz);
	r1.y = saturate(gWaterGlobals.y);
	r6.xyz = r0.xyz * WetDarken.xyz + -r0.xyz;
	r6.xyz = r1.yyy * r6.xyz + r0.xyz;
	r4 = (-r0.www >= 0) ? r6.xyz : r4.xyz;
	r6.xyz = (-r0.www >= 0) ? r2.xyz : r7.xyz;
	r3.x = specularColorFactor.x;
	r3.zw = (-r0.ww >= 0) ? r3.xy : r5.xy;
	r2.xyz = (-i.color.yyy >= 0) ? r2.xyz : r6.xyz;
	r0.xyz = (-i.color.yyy >= 0) ? r0.xyz : r4.xyz;
	r3.xy = (-i.color.yy >= 0) ? r3.xy : r3.zw;
	r4 = r2.xxx * i.texcoord4.xyz;
	r2.xzw = r2.zzz * i.texcoord1.xyz + r4.xyz;
	r2.xyz = r2.yyy * i.texcoord5.xyz + r2.xzw;
	r2.xyz = r2.xyz + 1E-05;
	r4 = normalize(r2.xyz);
	r0.w = saturate(-1 + i.color.x);
	o.color.xyz = r0.www * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r4.xyz * 0.5 + 0.5;
	r0.x = saturate(r3.y * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	o.color.w = r1.x;
	o.color1.w = r1.x;
	o.color2.x = r3.x;
	o.color2.w = r1.x;
	o.color3 = r1.wwwz * gStencil.x;

	return o;
}
